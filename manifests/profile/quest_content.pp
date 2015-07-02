class bootstrap::profile::quest_content {
  class { 'learning':
    require => Class['bootstrap::profile::install_pe'],
  }

}
