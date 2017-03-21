class bootstrap::profile::create_ap {
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # EPEL should already be installed as part of the Kickstart,
  # but make sure here.
  package { 'epel-release':
    ensure => present,
  }

  package { [ 'hostapd', 'haveged', 'wireless-tools' ]:
    ensure  => present,
    require => Package['epel-release'],
  }

  # Start the hardware entropy gathering daemon. Provides more
  # entropy to wireless encryption.
  service { 'haveged':
    ensure  => running,
    enable  => true,
    require => Package['haveged'],
  } 

  file { '/usr/bin/create_ap':
    mode   => '0755',
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/create_ap',
  }

  file { '/etc/create_ap.conf':
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/create_ap.conf',
  }

  file { '/usr/lib/systemd/system/create_ap.service':
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/create_ap.service',
  }

  $create_ap_service_deps = [
    Package['hostapd'],
    Package['haveged'],
    Package['wireless-tools'],
    Service['haveged'],    
    File['/usr/bin/create_ap'],
    File['/etc/create_ap.conf'],
    File['/usr/lib/systemd/system/create_ap.service']
  ]

  service { 'create_ap':
    ensure  => running,
    enable  => true,
    require => $create_ap_service_deps,
  }

}
