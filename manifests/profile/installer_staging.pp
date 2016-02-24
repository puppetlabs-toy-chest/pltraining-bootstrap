class bootstrap::profile::installer_staging {
  include bootstrap::params

  class { 'staging':
    path   => $bootstrap::params::source_path,
    owner  => 'root',
    group  => 'root',
  }
}
