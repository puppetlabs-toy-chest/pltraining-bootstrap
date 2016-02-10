class bootstrap::role::learning {
  include epel
  include localrepo
  include bootstrap
  class {'learning':
    git_branch => 'master',
  }
  class {'bootstrap::profile::splash':
    # Note: the $IP_ADDRESS string is a variable determined at boot time by rc.local
    login_message => file('bootstrap/learning_message')
  }
}
