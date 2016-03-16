class bootstrap::profile::splash ($login_message = "") {
  file {'/var/local/places.txt':
    ensure => file,
    source => 'puppet:///modules/bootstrap/places.txt',
  }

  file {'/etc/rc.d/rc.local':
    ensure  => file,
    content => template('bootstrap/rc.local.erb'),
    mode    => '0755',
  }
}
