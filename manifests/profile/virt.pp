class bootstrap::profile::virt {

  # Set up libvirt and network
  class { 'libvirt':
    defaultnetwork  => false,
    auth_unix_rw    => 'none',
    unix_sock_group => 'libvirt',
  }
  libvirt::network { 'classroom':
    ensure       => 'enabled',
    bridge       => 'virbr0',
    forward_mode => 'nat',
    domain_name  => 'puppetlabs.vm',
    autostart    => true,
    ip           => [{
      address    => '192.168.233.1',
      dhcp       => {
        start    => '192.168.233.1',
        end      => '192.168.233.254',
      }
    }],
  }
  libvirt_pool { 'default':
    ensure    => present,
    type      => 'dir',
    active    => true,
    autostart => true,
    target    => '/var/lib/libvirt/images/',
  }
  user {'training':
    groups => ['libvirt'],
  }

  # Add a hosts entry for the main ip so that dnsmasq will work
  host { $::fqdn:
    ip => $::ipaddress
  }

  file { '/etc/hostapd/hostapd.conf':
    ensure    => file,
    content   => epp('bootstrap/hostapd.conf.epp',{
      iface   => 'wlp3s0',
      hw_mode => 'g',
      channel => '1',
      ssid    => 'classroom_in_a_box',
      bridge  => 'virbr0',
    }),
    require => Package['hostapd'],
  }

  package {['kvm','dnsmasq','hostapd','iw']:
    ensure  => present,
    require => Class['epel'],
  }

  # Set dnsmasq to use the libvirt default network
  file { '/etc/dnsmasq.conf':
    ensure   => file,
    content  => 'interface=virbr0',
    require  => Package['dnsmasq'],
  }

  # Download VMs
  # TODO: This could be optimized to be more puppety
  file { '/usr/src/vms':
    ensure => directory,
  }
  file { '/usr/src/vms/windows.vhd':
    ensure => file,
    source => 'http://int-resources.ops.puppetlabs.net/EducationBeta/Windows/9600.16415.amd64fre.winblue_refresh.130928-2229_server_serverdatacentereval_en-us.vhd',
  }
  exec { 'qemu-img convert -O raw /usr/src/vms/windows.vhd /var/lib/libvirt/images/windows.img':
    path    => '/bin',
    require => File['/usr/src/vms/windows.vhd'],
  }
  file { '/usr/src/vms/puppet-master.ova':
    ensure => file,
    source => 'http://downloads.puppet.com/training/puppet-master.ova',
  }
  exec { 'tar xvf /usr/src/vms/puppet-master.ova':
    cwd     => '/usr/src/vms',
    path    => '/bin',
    require => File['/usr/src/vms/puppet-master.ova'],
  }
  exec { 'qemu-img convert -O raw /usr/src/vms/*.vmdk /var/lib/libvirt/images/master.img':
    path    => '/bin',
    require => Exec['tar xvf /usr/src/vms/puppet-master.ova'],
  }

}

