class bootstrap::role::learning {
  include localrepo
  include userprefs::profile
  include bootstrap
  include bootstrap::profile::rubygems
  include bootstrap::profile::network
  include bootstrap::profile::pe_tweaks
  include bootstrap::profile::stickler_server
  include bootstrap::profile::abalone
  include bootstrap::profile::puppet_forge_server
  include bootstrap::profile::learning::quest_guide
  include bootstrap::profile::learning::pe_tuning
  include bootstrap::profile::learning::install
  include bootstrap::profile::learning::quest_guide_server
  include bootstrap::profile::learning::ssh
  include bootstrap::profile::learning::quest_tool
  include bootstrap::profile::learning::multi_node
  include bootstrap::profile::learning::local_modules
  include bootstrap::profile::learning::learning_stickler_gems
  class { 'dockeragent':
    create_no_agent_image => true,
    lvm_bashrc            => true,
  }
  class { 'bootstrap::profile::cache_gems':
    use_stickler => true,
  }
  class { 'bootstrap::profile::ruby':
    install_bundler => true,
  }
  class { 'userprefs::bash':
    password => '$1$hgIZHl1r$tEqMTzoXz.NBwtW3kFv33/',
    replace  => true,
  }
  class {'userprefs::vim':
    line_number => 'false',
    require     => Class['userprefs::profile'],
  }
  class {'bootstrap::profile::splash':
    # Note: the $IP_ADDRESS string is a variable determined at boot time by rc.local
    login_message => file('bootstrap/learning_message')
  }
}
