# Add default memory settings after PE install

class bootstrap::profile::pe_tuning {
  file { '/etc/puppetlabs/puppet/hieradata/':
    ensure => directory
  }
  file { "/etc/puppetlabs/puppet/hieradata/${fqdn}.yaml":
    ensure => file,
    source => 'puppet:///modules/bootstrap/defaults.yaml',
  }
}
