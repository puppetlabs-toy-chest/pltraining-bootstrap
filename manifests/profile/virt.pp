class bootstrap::profile::virt {
  include libvirt
  package {'kvm':
    ensure => present,
  }
  network::bridge::dynamic {'br0':
    ensure => 'up',
  }
  network::if::bridge { 'eno16777728':
    ensure => 'up',
    bridge => 'br0',
  }
  file { '/usr/src/vms':
    ensure => directory,
  }
  file { '/usr/src/vms/windows.vhd':
    ensure => file,
    source => 'http://int-resources.ops.puppetlabs.net/EducationBeta/Windows/9600.16415.amd64fre.winblue_refresh.130928-2229_server_serverdatacentereval_en-us.vhd',
  }

  file { '/usr/src/vms/puppet-master.ova':
    ensure => file,
    source => 'http://downloads.puppetlabs.com/training/puppet-master.ova'
  }
}

