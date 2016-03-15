class bootstrap::disable_selinux {
  class { 'selinux':
    mode => 'disabled',
  }
}
