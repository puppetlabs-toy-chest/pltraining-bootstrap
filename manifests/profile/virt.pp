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

  file { "${image_location}/puppet-master.ova":
    ensure => file,
    source => 'http://downloads.puppetlabs.com/training/puppet-master.ova'
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

