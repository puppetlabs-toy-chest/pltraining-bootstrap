class bootstrap::profile::lms_get_pe {
  class {'bootstrap::profile::get_pe':
    pe_destination => '/usr/src',
  }
}
