class bootstrap::profile::vagrant {
  include virtualbox

  class { 'vagrant':
    version => '1.9.1',
    require => Class['virtualbox'],
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
