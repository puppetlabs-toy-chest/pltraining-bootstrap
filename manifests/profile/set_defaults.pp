# Add default memory settings after PE install

class bootstrap::profile::set_defaults {
  file { '/etc/puppetlabs/code/hieradata':
    ensure => directory,
    require => Class['bootstrap::profile::install_pe'],
  }
  file { '/etc/puppetlabs/code/hieradata/defaults.yaml':
    ensure => present,
    source => 'puppet:///modules/bootstrap/defaults.yaml',
    require => File['/etc/puppetlabs/code/hieradata'],
  }
}

