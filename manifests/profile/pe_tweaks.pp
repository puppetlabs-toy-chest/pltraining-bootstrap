class bootstrap::profile::pe_tweaks {
  
  $puppet_base_dir = '/opt/puppetlabs/puppet'
  $prod_module_path = '/etc/puppetlabs/code/environments/production/modules'


  augeas { "environment timeout":
    context => "/files/etc/puppetlabs/puppet/puppet.conf/agent",
    changes => [
      "set environment_timeout 0",
    ],
  }
  augeas { "disable deprecation warnings":
    context => "/files/etc/puppetlabs/puppet/puppet.conf/main",
    changes => [
      "set disable_warnings deprecations",
    ],
  }

  package { ['trollop','serverspec','rspec-its','rspec-core','rspec']:
    ensure   => present,
    provider => 'puppet_gem',
  }

}
