class bootstrap::profile::scripts {
  # Populate the VM with our helper scripts.
  file {'/usr/local/bin':
    ensure  => directory,
    recurse => true,
    replace => false,
    source  => '/usr/src/puppetlabs-training-bootstrap/scripts/classroom',
  }
}
