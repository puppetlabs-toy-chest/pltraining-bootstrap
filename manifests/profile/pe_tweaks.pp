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
  
  exec { 'install trollop':
    command => "${puppet_base_dir}/bin/gem install trollop -v 2.0",
    unless  => "${puppet_base_dir}/bin/gem list trollop -i",
  }
  exec { 'install serverspec':
    command => "${puppet_base_dir}/bin/gem install serverspec -v 1.16.0",
    unless  => "${puppet_base_dir}/bin/gem list serverspec -i",
  }
  exec { 'install rspec-its':
    command => "${puppet_base_dir}/bin/gem install rspec-its -v 1.0.1",
    unless  => "${puppet_base_dir}/bin/gem list rspec-its -i",
  }
  exec { 'install rspec-core':
    command => "${puppet_base_dir}/bin/gem install rspec-core -v 2.99.0",
    unless  => "${puppet_base_dir}/bin/gem list rspec -i",
  }
  exec { 'install rspec':
    command => "${puppet_base_dir}/bin/gem install rspec -v 2.99.0",
    unless  => "${puppet_base_dir}/bin/gem list rspec -i",
  }

}
