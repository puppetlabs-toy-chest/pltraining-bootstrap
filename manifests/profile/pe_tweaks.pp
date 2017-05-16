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

  # to use pe_gem to install the following gems, we first need pe_gem installed
  # using execs now till there is a more graceful solution

  package { 'trollop':
    ensure   => '2.0',
    provider => 'puppet_gem',
  }
  package { 'serverspec':
    ensure   => '1.16.0',
    provider => 'puppet_gem',
  }
  package { 'rspec-its':
    ensure   => '1.0.1',
    provider => 'puppet_gem',
  }
  package { 'rspec-core':
    ensure   => '2.99.0',
    provider => 'puppet_gem',
  }
  package { 'rspec':
    ensure   => '2.99.0',
    provider => 'puppet_gem',
  }

  file {'/etc/puppetlabs/puppet/hieradata/tuning.yaml':
    ensure => file,
    source => 'puppet:///modules/bootstrap/tuning.yaml',
  }

}
