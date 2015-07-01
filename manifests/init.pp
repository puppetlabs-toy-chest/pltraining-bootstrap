class bootstrap {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  # Moving the root user declaration to the userprefs module.
  # user { 'root':
  #   password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
  # }
  file { '/usr/bin/envpuppet':
    source => 'puppet:///modules/bootstrap/envpuppet',
    mode   => '0755',
  }

  # This script generates the initial root SSH key for the fundamentals git workflow
  if $::hostname =~ /train/ {
    file { '/root/.ssh_keygen.sh':
      ensure => file,
      source => 'puppet:///modules/bootstrap/ssh_keygen.sh',
      mode   => 0755,
    }
    # Disable GSSAPIAuth for training VM.
    # The learning VM has a quest that relates to this, so leave
    # it enabled for the LVM.
    augeas { "GSSAPI_disable":
      context => '/files/etc/ssh/sshd_config',
      changes => 'set GSSAPIAuthentication no',
    }

  }
  if $::hostname =~ /learn/ {
    # Enable GSSAPIAuth for learning VM.
    # The learning VM has a quest that relates to this, so leave
    # it enabled for the LVM.
    augeas { "GSSAPI_enable":
      context => '/files/etc/ssh/sshd_config',
      changes => 'set GSSAPIAuthentication yes',
    }

  }
  # This shouldn't change anything, but want to make sure it actually IS laid out the way I expect.
  file {'/etc/rc.local':
    ensure => symlink,
    target => 'rc.d/rc.local',
    mode   => 0755,
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  # Make sure the firewall isn't running
  service { 'iptables':
    enable => false,
    ensure => stopped,
  }
  # Add a few extra packages for convenience
  package { [ 'patch', 'screen', 'telnet', 'tree' ] :
    ensure  => present,
    require => Class['localrepo'],
  }

  # need rubygems to cache rubygems
  package { 'rubygems' :
    ensure  => present,
    require => Class['localrepo'],
    before  => Class['bootstrap::cache_gems'],
  }

  file { '/etc/sysconfig/network':
    ensure  => file,
    content => template('bootstrap/network.erb'),
  }
  service { 'network':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/sysconfig/network'],
    hasstatus => true,
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  # Remove the udev ethernet naming rules, causes problems when
  # moving VMs around. This works for rhel/centos
  file {'/etc/udev/rules.d/70-persistent-net.rules':
    ensure   => absent,
    force    => true,
  }

  # Disable GSS-API for SSH to speed up log in
  $ruby_aug_package = $::osfamily ? {
    'RedHat' => 'ruby-augeas',
    'Debian' => 'libaugeas-ruby',
  }

  package { 'ruby_augeas_lib':
    ensure  => 'present',
    name    => $ruby_aug_package,
    require => Class['localrepo']
  }

  # Cache forge modules locally in the vm:
  class { 'bootstrap::cache_modules': cache_dir => '/usr/src/forge' }

  # Cache gems locally in the vm:
  class { 'bootstrap::cache_gems': }

  # configure user environment
  include userprefs::defaults

  include bootstrap::splash

  include bootstrap::yum

}
