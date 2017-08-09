class bootstrap::profile::cache_modules {
  include bootstrap::params
  $stagedir = $bootstrap::params::stagedir
  $codedir  = $bootstrap::params::codedir

  File {
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode  => '0644',
  }

  file { [$stagedir, $codedir]:
    ensure => directory,
  }

  file { "${stagedir}/Puppetfile":
    ensure => file,
    source => 'puppet:///modules/bootstrap/Puppetfile',
    notify => Exec['install modules'],
  }

  exec { 'install modules':
    command     => "r10k puppetfile install",
    path        => '/bin:/usr/bin:/opt/puppetlabs/bin',
    cwd         => $stagedir,
    refreshonly => true,
  }

  file { "${codedir}/modules":
    ensure  => directory,
    source  => "${stagedir}/modules",
    recurse => true,
    require => Exec['install modules'],
  }
}
