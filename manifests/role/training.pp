class bootstrap::role::training inherits bootstrap::params {
  include bootstrap
  include bootstrap::profile::ruby
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_rpms
  include bootstrap::profile::cache_docker
  include bootstrap::profile::pdf_stack
  include bootstrap::profile::network
  include userprefs::defaults
  include bootstrap::profile::splash
  include bootstrap::profile::cache_wordpress
  include bootstrap::profile::cache_gems
  class { 'bootstrap::public_key': 
    ec2_lock_passwd => false,
  }
  include bootstrap::profile::disable_selinux 
  class { 'abalone':
    port     => '9091',
    watchdog => true,
  }
}
