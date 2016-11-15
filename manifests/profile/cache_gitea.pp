class bootstrap::profile::cache_gitea (
  $bucket_url   = 'https://s3-us-west-2.amazonaws.com/education-packages/',
  $package_name = 'gitea-1.0-1.x86_64.rpm',
){

  file { '/usr/src/rpm_cache':
    ensure => directory,
  }

  exec { 'cache gitea rpm':
    cwd       => '/usr/src/rpm_cache',
    command   => "/usr/bin/wget -nc ${bucket_url}${package_name} -O gitea.rpm",
    creates   => '/usr/src/rpm_cache/gitea.rpm',
    logoutput => 'on_failure',
    user      => 'root',
    group     => 'root',
    require   => File['/usr/src/rpm_cache'],
  }
}
