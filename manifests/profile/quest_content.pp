class bootstrap::profile::quest_content {
  class { 'learning':
    git_branch => 'master',
    require    => Class['bootstrap::profile::install_pe']
  }
  contain learning
}
