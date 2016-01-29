class bootstrap::public_key ( $admin_user = $bootstrap::params::admin_user ) {
  ssh_authorized_key { 'instructor':
    user => $admin_user,
    type => 'ssh_rsa',
    key  => file('puppet:///bootstrap/training.pub'),
  }
}
