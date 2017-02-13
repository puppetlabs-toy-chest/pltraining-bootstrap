class bootstrap::role::ciab (
  $pe_version = $bootstrap::params::pe_version
) inherits bootstrap::params {
  include localrepo
  include bootstrap
  include bootstrap::profile::cache_modules
  include userprefs::defaults
  include bootstrap::profile::virt
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
