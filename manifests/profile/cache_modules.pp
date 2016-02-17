class bootstrap::profile::cache_modules(
  $cache_dir = '/usr/src/forge',
) {

  file { $cache_dir:
    ensure => directory,
  }

  exec { 'cache modules':
    command => "puppet module install pltraining-classroom --modulepath=${cache_dir}",
    creates => "${cache_dir}/classroom",
    path    => '/opt/puppetlabs/bin',
    require => File[$cache_dir],
  }
}
