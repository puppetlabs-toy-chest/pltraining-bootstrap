class bootstrap::profile::learning::pypi_server ( $pypi_dir = '/opt/pypiserver', $pypi_pkg_dir = '/opt/pypiserver/packages' ) {

  package { 'pypiserver':
    ensure => present,
    provider => 'pip',
  }

  file { [$pypi_dir, $pypi_pkg_dir]:
    ensure => directory,
    mode => '0640',
    before => Supervisord::Program['pypi-server'],
  }

  class { 'supervisord':
    install_pip => true,
    setuptools_url => 'https://bootstrap.pypa.io/ez_setup.py',
  }

  supervisord::program { 'pypi-server':
    command     => "pypi-server -p 8180 ${pypi_pkg_dir}",
    user        => 'root',
    autostart   => true,
    autorestart => true,
    priority    => '100',
  }

  $pip_conf = @(END)
  [global]
  index-url = http://localhost:8180/simple/
  | END

  file { ['/root/.config','/root/.config/pip']:
    ensure => directory,
  }

  file { '/root/.config/pip/pip.conf':
    ensure  => present,
    content => $pip_conf,
    require => Package['pypiserver'],
  }
  
}
