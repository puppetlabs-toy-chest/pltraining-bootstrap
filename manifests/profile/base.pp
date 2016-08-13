class bootstrap::profile::base {
  include epel

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
    mode   => '0755',
  }

  # Add a few extra packages for convenience
  package { [ 'patch',
              'jq',
              'screen', 
              'ntpdate', 
              'telnet',
              'tree', 
              'stunnel', 
              'redhat-lsb' ] :
    ensure  => present,
    require => Class['epel'],
  }

  # /etc/puppet/ssl is confusing to have around. Sloppy. Kill.
  file {'/etc/puppet':
    ensure  => absent,
    recurse => true,
    force   => true,
  }
}
