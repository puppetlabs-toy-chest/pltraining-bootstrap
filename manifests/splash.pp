class bootstrap::splash ($print_console_login = false,
                         $login_message = "") {
  file {'/etc/rc.d/rc.local':
    ensure  => file,
    content => template('bootstrap/rc.local.erb'),
    mode    => 0755,
  }
}
