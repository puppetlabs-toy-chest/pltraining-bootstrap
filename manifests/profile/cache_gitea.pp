# DEPRECATED: This class is deprecated and should be removed after two
#             pltraining-classroom module releases
#
# NOTE: The gitea RPM is built from the Vagrant environment in the
#       pltraining-gitea-build repository. Please see
#       https://github.com/puppetlabs/pltraining-gitea-build for detailed
#       instructions to build an updated RPM.
class bootstrap::profile::cache_gitea (
  $bucket_url   = 'https://s3-us-west-2.amazonaws.com/education-packages/',
  $package_name = 'gitea-1.6.0-0.x86_64.rpm',
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
