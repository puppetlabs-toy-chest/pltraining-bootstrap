class bootstrap::profile::ciab_web_interface {
  File {
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Contain here because ordering dependencies are set on the
  # ciab_web_interface class
  contain nginx

  $docroot = '/usr/share/nginx/html'

  file { "${docroot}/index.html":
    content => epp('bootstrap/ciab_web_interface/index.epp'),
    # This exec is in bootstrap::profile::vagrant
    require => Exec['generate master IP address fact'],
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
