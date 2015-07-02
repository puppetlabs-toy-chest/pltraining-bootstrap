class bootstrap::profile::quest_content {
  class { 'learning':
    git_branch => 'master',
    require    => Exec['install-pe']
  }
}
