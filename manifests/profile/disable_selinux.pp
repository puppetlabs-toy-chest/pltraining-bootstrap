class bootstrap::profile::disable_selinux {
  class { 'selinux':
    mode => 'disabled',
  }
}
