class bootstrap::profile::cache_wordpress (
  $cache_dir        = '/usr/src/wordpress',
  $manage_cache_dir = true,
) {

  if $manage_cache_dir {
    file { $cache_dir:
      ensure => directory,
    }

    $exec_dep = File[$cache_dir]
  } else {
    $exec_dep = undef
  }

  exec { 'Cache WordPress':
    cwd       => $cache_dir,
    command   => '/usr/bin/wget --no-clobber --no-check-certificate https://www.wordpress.org/wordpress-3.8.tar.gz',
    creates   => "${cache_dir}/wordpress-3.8.tar.gz",
    logoutput => 'on_failure',
    user      => 'root',
    group     => 'root',
    require   => $exec_dep,
  }
}

