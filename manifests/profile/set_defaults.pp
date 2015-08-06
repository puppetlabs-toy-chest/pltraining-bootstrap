# Add default memory settings after PE install

class bootstrap::profile::set_defaults {
  exec { 'mkdir -p /etc/puppetlabs/code':
    path   => '/bin',
    before => [File['/etc/puppetlabs/code/hiera.yaml','/etc/puppetlabs/code/hieradata'],Class['bootstrap::profile::install_pe']]
  }
  file { '/etc/puppetlabs/code/hiera.yaml':
    ensure  => file,
    source  => 'puppet:///modules/bootstrap/hiera.yaml',
  }
  file { '/etc/puppetlabs/code/hieradata':
    ensure => directory,
  }
  file { '/etc/puppetlabs/code/hieradata/defaults.yaml':
    ensure => file,
    source => 'puppet:///modules/bootstrap/defaults.yaml',
    require => File['/etc/puppetlabs/code/hieradata'],
  }
}

