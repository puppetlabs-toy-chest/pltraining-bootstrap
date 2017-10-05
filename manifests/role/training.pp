class bootstrap::role::training inherits bootstrap::params {
  include bootstrap
  include userprefs::defaults
  include bootstrap::profile::ruby
  include bootstrap::profile::rubygems
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_rpms
  include bootstrap::profile::cache_docker
  include bootstrap::profile::pdf_stack
  include bootstrap::profile::network
  include bootstrap::profile::splash
  include bootstrap::profile::cache_wordpress
  include bootstrap::profile::cache_gems
  include bootstrap::profile::disable_selinux

  class { 'bootstrap::public_key':
    ec2_lock_passwd => false,
    additional_key  => $bootstrap::params::additional_key,
  }

  class { 'abalone':
    port     => '9091',
    watchdog => true,
    require  => Class['bootstrap::profile::rubygems'],
  }
}
