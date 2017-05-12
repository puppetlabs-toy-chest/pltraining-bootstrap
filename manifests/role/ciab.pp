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
  include bootstrap::profile::ciab_web_interface

  class { 'bootstrap::profile::cache_wordpress':
    cache_dir => '/usr/share/nginx/html',
  }

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
  Class['bootstrap::profile::vagrant']
  -> Class['bootstrap::profile::guacamole']

  # Get all of the vagrant boxes in place before creating the CIAB web
  # interface page, and get the nginx installation in place before caching
  # the wordpress tarball in the nginx docroot
  Class['bootstrap::profile::vagrant']
  -> Class['bootstrap::profile::ciab_web_interface']
  -> Class['bootstrap::profile::cache_wordpress']
}
