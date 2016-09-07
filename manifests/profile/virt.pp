class bootstrap::profile::virt {

  # Set up libvirt and network
  include libvirt
  package {['kvm','dnsmasq','hostapd']:
    ensure => present,
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

