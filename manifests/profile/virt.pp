class bootstrap::profile::virt {

  # Set up libvirt and network
  include libvirt
  package {'kvm':
    ensure => present,
  }
  network::bridge::dynamic {'br0':
    ensure => 'up',
  }
  if $networking['primary'] != 'br0' {
    network::if::bridge { $networking['primary']:
      ensure => 'up',
      bridge => 'br0',
    }
  }


  # Download VMs
  file { '/usr/src/vms':
    ensure => directory,
  }
  file { '/usr/src/vms/windows.vhd':
    ensure => file,
    source => 'http://int-resources.ops.puppetlabs.net/EducationBeta/Windows/9600.16415.amd64fre.winblue_refresh.130928-2229_server_serverdatacentereval_en-us.vhd',
  }
  file { '/usr/src/vms/puppet-master.ova':
    ensure => file,
    source => 'http://downloads.puppet.com/training/puppet-master.ova'
  }

}

