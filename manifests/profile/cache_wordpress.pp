class bootstrap::profile::cache_wordpress (
  $cache_dir = '/usr/src/wordpress',
) {

  file { $cache_dir:
    ensure => directory,
  }

  exec { 'Cache WordPress':
    cwd       => $cache_dir,
    command   => '/usr/bin/wget --no-clobber --no-check-certificate https://www.wordpress.org/wordpress-3.8.tar.gz',
    creates   => "${cache_dir}/wordpress-3.8.tar.gz",
    logoutput => 'on_failure',
    user      => 'root',
    group     => 'root',
    require   => File[$cache_dir],
  }
}

