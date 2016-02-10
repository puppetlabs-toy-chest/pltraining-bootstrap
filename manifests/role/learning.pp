class bootstrap::role::learning {
  include epel
  include localrepo
  include bootstrap
  include bootstrap::profile::learning_splash
  class {'learning':
    git_branch => 'master',
  }
}
