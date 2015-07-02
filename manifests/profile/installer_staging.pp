class bootstrap::profile::installer_staging {
  class { 'staging':
    path   => '/usr/src/installer/',
    owner  => 'root',
    group  => 'root',
    before => Class['install_pe'],
  }
}
