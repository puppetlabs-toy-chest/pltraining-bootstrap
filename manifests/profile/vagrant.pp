class bootstrap::profile::vagrant {
  include virtualbox

  class { 'vagrant':
    version => '1.9.1',
    require => Class['virtualbox'],
  }

  $vagrant_plugins = [
    'oscar', 'vagrant-hosts', 'vagrant-auto_network', 'vagrant-pe_build',
    'vagrant-vbguest', 'vagrant-vbox-snapshot', 'vagrant-reload'
  ]

  vagrant::plugin { $vagrant_plugins:
    user => 'training',
    require => Class['vagrant'],
  }

  # Convert the latest Puppet master instructor OVA and install as a
  # Vagrant box
  vagrant::box { 'current-puppet-master-ova':
    user   => 'training',
    source => 'http://downloads.puppetlabs.com/training/puppet-master.ova',
    require => Class['vagrant'],
  }

  # Convert the latest Puppet master instructor OVA and install as a
  # Vagrant box
  vagrant::box { 'current-puppet-student-ova':
    user   => 'training',
    source => 'http://downloads.puppetlabs.com/training/puppet-student.ova',
    require => Class['vagrant'],
  }
}
