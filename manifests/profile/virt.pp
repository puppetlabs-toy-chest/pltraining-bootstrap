class bootstrap::profile::virt {

  image_location = '/var/lib/libvirt/images'

  # Set up libvirt and network
  class { 'libvirt':
    unix_sock_group    => 'libvirt',
    unix_sock_rw_perms => '0770',
    auth_unix_rw       => 'none',
  }
  user {'training':
    groups  => ['libvirt'],
    require => Class['libvirt'],
  }
  package {['kvm','virt-manager']:
    ensure => present,
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
  file { "${image_location}":
    ensure => directory,
  }
  file { "${image_location}/windows.vhd":
    ensure => file,
    source => 'http://int-resources.ops.puppetlabs.net/EducationBeta/Windows/9600.16415.amd64fre.winblue_refresh.130928-2229_server_serverdatacentereval_en-us.vhd',
  }
  exec { 'convert windows image':
    command => 'qemu-img convert -f vpc -O raw windows.vhd windows.img && rm -rf windows.vhd',
    cwd     => $image_location,
    path    => '/bin',
    require => File["${image_location}/windows.vhd"],
  }

  exec { "qemu-img convert -O raw ${image_location}/windows.vhd /var/lib/libvirt/images/windows.img":
    path    => '/bin',
    require => File["${image_location}/windows.vhd"],
  }

  file { "${image_location}/puppet-master.ova":
    ensure => file,
    source => 'http://downloads.puppet.com/training/puppet-master.ova',
  }
  exec { "tar xvf ${image_location}/puppet-master.ova":
    cwd     => '/usr/src/vms',
    path    => '/bin',
    require => File['${image_location}/puppet-master.ova'],
  }
  exec { "qemu-img convert -O raw ${image_location}/*.vmdk /var/lib/libvirt/images/master.img":
    path    => '/bin',
    require => Exec["tar xvf ${image_location}/puppet-master.ova"],
  }
  exec { 'convert master image':
    command => 'tar xvf puppet-master.ova *.vmdk && rm -rf puppet-master.ova',
    cwd     => $image_location,
    path    => '/bin',
    require => File["${image_location}/puppet-master.ova"],
  }
  exec { 'qemu-img convert -f vmdk -O raw *.vmdk master.img && rm -rf *.vmdk':
    cwd     => $image_location,
    path    => '/bin',
    require => Exec['convert master image']
  }

}

