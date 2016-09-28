class bootstrap::role::demo {
  include localrepo
  include bootstrap
  include bootstrap::profile::network
  include bootstrap::profile::pe_tweaks
  include userprefs::profile
  class { 'userprefs::bash':
    password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
    replace  => true,
  }
  class {'userprefs::vim':
    line_number => 'false',
    require     => Class['userprefs::profile'],
  }
  class {'learning':
    git_branch => 'master',
    content_repo_name = 'puppetconf-edu-demo'
  }
  class {'bootstrap::profile::splash':
    # Note: the $IP_ADDRESS string is a variable determined at boot time by rc.local
    login_message => file('bootstrap/learning_message')
  }
}
