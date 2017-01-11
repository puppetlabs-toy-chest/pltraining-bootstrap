class bootstrap::profile::vagrant {
  class { 'virtualbox':
    package_ensure => '5.1',
  }
}
