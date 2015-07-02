class bootstrap::profile::quest_content {
  class { 'learning':
    git_branch => 'master',
    require    => Class['bootstrap::profile::learning_install_pe']
  }
  contain learning
}
