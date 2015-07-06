class bootstrap::profile::splash ($login_message = "") {
  file {'/etc/rc.d/rc.local':
    ensure  => file,
    content => template('bootstrap/rc.local.erb'),
    mode    => 0755,
  }
}
