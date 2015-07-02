class bootstrap::profile::learning_install_pe {
  class {'bootstrap::profile::install_pe':
    before => Class['bootstrap::profile::quest_content']
  }
}
