class bootstrap::profile::base {
  include bootstrap::params
  include epel
  include sudo

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  user { $bootstrap::params::admin_user:
    ensure     => present,
    managehome => true,
  }
  sudo::conf { $bootstrap::params::admin_user:
    content => "${bootstrap::params::admin_user} ALL=(ALL) NOPASSWD: ALL",
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
    mode   => '0755',
  }

  # Add a few extra packages for convenience
  package { [ 'patch',
              'git',
              'jq',
              'screen',
              'ntpdate',
              'telnet',
              'tree',
              'stunnel',
              'redhat-lsb',
              'zsh',
              'tcsh',
              'csh' ] :
    ensure  => present,
    require => Class['epel'],
  }

  package { 'jgrep':
    ensure   => present,
    provider => gem,
  }

  # make the console text usable again. It's way too high resolution for a VM by default.
  kernel_parameter { 'vga':
    ensure => present,
    value  => '832',  # 800x600 @ 32bit
  }

  file {'/etc/puppetlabs-release':
    ensure  => file,
    content => $bootstrap::params::ptb_version,
  }

  # Enable PrintMotd for classroom VMs.
  # See: https://tickets.puppetlabs.com/browse/COURSES-2240
  augeas { "PrintMotd_enable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set PrintMotd yes',
    require => Package['ruby-augeas'],
  }
  augeas { "UsePAM_enable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set UsePAM yes',
    require => Package['ruby-augeas'],
  }
}
