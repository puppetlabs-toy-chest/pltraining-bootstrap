class bootstrap::profile::cache_modules {
  require bootstrap::profile::pe_master
  include bootstrap::params

  $stagedir  = $bootstrap::params::stagedir
  $codedir   = $bootstrap::params::codedir
  $hieradata = "${codedir}/environments/production/hieradata"

  File {
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode  => '0644',
  }

  file { [$stagedir, $codedir, $hieradata]:
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

  # Ensure that the redirect setting persists post install
  # This will be replaced by filesync as soon as the classroom is classified.
  file { "${hieradata}/common.yaml":
    ensure => file,
    source => 'puppet:///modules/bootstrap/hieradata/common.yaml',
  }

  file { "${codedir}/modules":
    ensure  => directory,
    source  => "${stagedir}/modules",
    recurse => true,
    require => Exec['install modules'],
  }
}
