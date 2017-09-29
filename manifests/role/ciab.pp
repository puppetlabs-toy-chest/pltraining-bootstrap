class bootstrap::role::ciab inherits bootstrap::params {
  include bootstrap
  include bootstrap::profile::ruby
  include bootstrap::profile::rubygems
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include bootstrap::profile::cache_rpms
  include bootstrap::profile::abalone
  include userprefs::defaults
  include bootstrap::profile::create_ap
  include bootstrap::profile::vagrant
  include bootstrap::profile::splash
  include bootstrap::profile::guacamole
  include bootstrap::profile::ciab_web_interface

  class { 'bootstrap::profile::cache_wordpress':
    cache_dir        => '/usr/share/nginx/html',
    manage_cache_dir => false,
  }

  class { 'bootstrap::public_key': 
    ec2_lock_passwd => false,
  }

  include bootstrap::profile::disable_selinux 

  # Start the wifi access point before the vagrant boxes are provisioned
  Class['bootstrap::profile::create_ap'] ->
    Class['bootstrap::profile::vagrant']

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
