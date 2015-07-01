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

  # This shouldn't change anything, but want to make sure it actually IS laid out the way I expect.
  file {'/etc/rc.local':
    ensure => symlink,
    target => 'rc.d/rc.local',
    mode   => 0755,
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

  include bootstrap::ruby

  # Cache forge modules locally in the vm:
  class { 'bootstrap::cache_modules': cache_dir => '/usr/src/forge' }

  # Cache gems locally in the vm:
  class { 'bootstrap::cache_gems': }

  # configure user environment
  include userprefs::defaults

  include bootstrap::splash

  include bootstrap::yum

  include bootstrap::ssh
}
