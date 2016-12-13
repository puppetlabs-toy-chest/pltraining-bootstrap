class bootstrap::profile::deployer(
  $password = 'puppetlabs',
) {
  rbac_user {'deployer':
    ensure       => present,
    display_name => 'deployer',
    email        => 'deployer@puppetlabs.vm',
    password     => $password,
    roles        => 4,
  }
}
