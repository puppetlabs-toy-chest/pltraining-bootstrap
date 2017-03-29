class bootstrap::role::ciab inherits bootstrap::params {
  include localrepo
  include bootstrap
  include bootstrap::profile::ruby
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include userprefs::defaults
  include bootstrap::profile::vagrant
  include bootstrap::profile::splash
  include bootstrap::profile::guacamole
  include bootstrap::profile::nginx_proxy
  class { 'bootstrap::public_key': 
    ec2_lock_passwd => false,
  }
  include bootstrap::profile::disable_selinux 
  class { 'abalone':
    port => '9091'
  }

  # If we are not in offline mode, make sure to stop the create_ap
  # service so the CIAB is not acting as a hotspot
  if !str2bool($::offline) {
    service { 'create_ap':
      ensure => stopped,
      enable => false,
    }
  }

  # Get all of the vagrant boxes in place before configuring guacamole to
  # connect to them
  Class['bootstrap::profile::vagrant'] -> Class['bootstrap::profile::guacamole']
}
