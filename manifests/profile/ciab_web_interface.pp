class bootstrap::profile::ciab_web_interface {
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Retrieve the IP address from the proper interface, depending on whether
  # the CIAB is configured for online or offline ("hotspot") mode.
  if str2bool($::offline) {
    $ciab_ip = $::networking['interfaces']['ap0']['bindings'][0]['address']
  } else {
    $ciab_ip = $::networking['ip']
  }

  # Contain here because ordering dependencies are set on the
  # ciab_web_interface class so these resources are applied after
  # the bootstrap::profile::vagrant class
  contain nginx

  $docroot = '/usr/share/nginx/html'

  file { "${docroot}/index.html":
    content => epp('bootstrap/ciab_web_interface/index.html.epp',
                    { ciab_ip => $ciab_ip } ),
  }

  file { "${docroot}/Puppet-Logo-Amber-White-sm.png":
    source => 'puppet:///modules/bootstrap/ciab_web_interface/Puppet-Logo-Amber-White-sm.png',
  }

  file { "${docroot}/css":
    ensure => directory,
  }

  file { "${docroot}/css/ciab.css":
    source => 'puppet:///modules/bootstrap/ciab_web_interface/css/ciab.css',
  }
}
