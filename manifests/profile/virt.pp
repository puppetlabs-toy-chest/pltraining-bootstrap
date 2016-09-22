class bootstrap::profile::virt {

  $image_location = '/var/lib/libvirt/images'
  $image_source = '/usr/src/vms'

  # Set up libvirt and network
  user {'training':
    groups  => ['libvirt'],
    require => Class['libvirt'],
  }
  class { 'libvirt':
    qemu_vnc_listen    => '0.0.0.0',
    listen_tcp         => true,
    defaultnetwork     => false,
    auth_unix_rw       => 'none',
    unix_sock_group    => 'libvirt',
    unix_sock_rw_perms => '0770',
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
  file { [$image_source,$image_location]:
    ensure => directory,
  }
  file { "${image_source}/windows.vhd":
    ensure => file,
    source => 'http://int-resources.ops.puppetlabs.net/EducationBeta/Windows/9600.16415.amd64fre.winblue_refresh.130928-2229_server_serverdatacentereval_en-us.vhd',
  }
  exec { 'convert windows image':
    command => "qemu-img convert -f vpc -O raw ${image_source}/windows.vhd windows.img",
    cwd     => $image_location,
    path    => '/bin',
    creates => "${image_location}/windows.img",
    require => File["${image_source}/windows.vhd"],
  }

  file { "${image_source}/puppet-master.ova":
    ensure => file,
    source => 'http://downloads.puppet.com/training/puppet-master.ova',
    notify => Exec['expand master image']
  }
  exec { 'expand master image':
    command     => "tar xvf ${image_source}/puppet-master.ova *.vmdk",
    cwd         => $image_source,
    path        => '/bin',
    refreshonly => true,
    require     => File["${image_source}/puppet-master.ova"],
  }
  exec { 'convert master image':
    command => "qemu-img convert -f vmdk -O raw ${image_source}/*.vmdk master.img && rm -rf ${image_sourcE}/*.vmdk",
    cwd     => $image_location,
    path    => '/bin',
    creates => "${image_location}/master.img",
    require => Exec['expand master image']
  }

}
