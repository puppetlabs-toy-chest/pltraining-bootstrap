class bootstrap::profile::cache_modules(
  $cache_dir = '/usr/src/forge',
) {
  Bootstrap::Forge {
    cache_dir => $cache_dir,
  }

  file { $cache_dir:
    ensure => directory,
  }

  exec { 'cache modules':
    command => "puppet module install pltraining-classroom --modulepath=${cachedir}",
    creates => "${cachedir}/classroom",
    path    => '/opt/puppetlabs/bin',
    require => File[$cache_dir],
  }
}
