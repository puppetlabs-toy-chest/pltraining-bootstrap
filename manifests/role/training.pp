class bootstrap::role::training (
  $pe_version = $bootstrap::params::pe_version
) inherits bootstrap::params {
  include localrepo
  include bootstrap
  include bootstrap::profile::network
  include userprefs::defaults
  include bootstrap::profile::splash
  include bootstrap::profile::cache_wordpress
  include bootstrap::profile::installer_staging
  include bootstrap::profile::get_pe
  class { 'bootstrap::public_key': 
    ec2_lock_passwd => false,
  }
  include bootstrap::profile::disable_selinux 
  class { 'abalone':
    port => '9091'
  }
}
