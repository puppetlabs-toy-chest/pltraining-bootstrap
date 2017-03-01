# Pre-install the graphite packages to speed up installation and
# enable offline use.

class bootstrap::profile::learning::graphite_reqs ($pypi_dir = '/opt/pypiserver', $pypi_pkg_dir = '/opt/pypiserver/packages') {

  include bootstrap::profile::learning::pypi_server

  # Set package default to require a pip-python symlink to /usr/bin/pip
  Package {
    require => File['/usr/bin/pip-python'],
  }  

  #Define the files we need to cache for pip
  $pypi_root = "https://pypi.python.org/packages/source"
  $pip_urls = [
    "${pypi_root}/D/Django/Django-1.5.tar.gz",
    "${pypi_root}/c/carbon/carbon-0.9.15.tar.gz",
    "${pypi_root}/T/Twisted/Twisted-11.1.0.tar.bz2",
    "${pypi_root}/t/txAMQP/txAMQP-0.4.tar.gz",
    "${pypi_root}/g/graphite-web/graphite-web-0.9.15.tar.gz",
    "${pypi_root}/d/django-tagging/django-tagging-0.3.1.tar.gz",
    "${pypi_root}/w/whisper/whisper-0.9.15.tar.gz"
  ]

  #Use our defined resource type to wget all these packages
  $pip_urls.each | $url | {
    bootstrap::profile::learning::pypi_cached_pkg { $url:
      pypi_pkg_dir => $pypi_pkg_dir,
      require => Class['bootstrap::profile::learning::pypi_server'],
    }
  }

  # Install some Graphite dependencies with the default provider (yum)
  package { ['libffi-devel', 'openssl-devel', 'python-devel']:
    ensure => present,
  }

  # Install requests
  # The pip provider doesn't support this syntax, so use an exec
  exec { 'install requests':
    command => '/bin/pip install requests --index "https://pypi.python.org/simple/"',
    require => Package['libffi-devel','openssl-devel', 'python-devel'],
  }

  # Now that we've installed the requests[security] stuff we can get python-sqlite3dbm
  package { 'python-sqlite3dbm':
    ensure => '0.1.4-6.el7',
    provider => 'yum',
    require => Exec['install requests'],
  }
}
