class bootstrap::profile::ciab_web_interface {
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # The CIAB will always have a known address (10.0.0.1) based on the
  # access point
  $ciab_ip = $::networking.dig('interfaces', 'ap0', 'bindings', 0, 'address')

  if $ciab_ip and $facts['master_ports'] {
    # Contain here because ordering dependencies are set on the
    # ciab_web_interface class so these resources are applied after
    # the bootstrap::profile::vagrant class
    contain nginx

    $docroot = '/usr/share/nginx/html'

    file { "${docroot}/index.html":
      content => epp('bootstrap/ciab_web_interface/index.html.epp',
                     { ciab_ip => $ciab_ip } ),
      require => Class['nginx'],
    }

    file { "${docroot}/Puppet-Logo-Amber-White-sm.png":
      source  => 'puppet:///modules/bootstrap/ciab_web_interface/Puppet-Logo-Amber-White-sm.png',
      require => Class['nginx'],
    }

    file { "${docroot}/css":
      ensure  => directory,
      require => Class['nginx'],
    }

    file { "${docroot}/css/ciab.css":
      source  => 'puppet:///modules/bootstrap/ciab_web_interface/css/ciab.css',
      require => Class['nginx'],
    }
  }
}
