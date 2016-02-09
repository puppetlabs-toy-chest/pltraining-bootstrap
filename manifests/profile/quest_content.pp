class bootstrap::profile::quest_content {
  class { 'learning':
    git_branch => 'master',
  }
  contain learning
}
