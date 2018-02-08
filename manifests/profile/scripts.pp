class bootstrap::profile::scripts {
  # Populate the VM with our helper scripts.
  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
  file {'/usr/local/bin':
    ensure  => directory,
    recurse => true,
    replace => false,
    source  => 'puppet:///modules/bootstrap/scripts/classroom',
  }

  # I'm not sure these even need to be managed. The scripts that used them were
  # deprecated and replaced with the classroom gem, which declares dependencies.
  package { ['puppetdb-ruby', 'colorize', 'puppetclassify']:
    ensure   => present,
    provider => puppet_gem,
  }
}
