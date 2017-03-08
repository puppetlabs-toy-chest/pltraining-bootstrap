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
}
