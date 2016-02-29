class bootstrap::role::training (
  $pe_version = $bootstrap::params::pe_version
) {
  include epel
  include localrepo
  include bootstrap
  include bootstrap::profile::splash
  include bootstrap::profile::cache_wordpress
  include bootstrap::profile::installer_staging
  class { 'bootstrap::profile::get_pe':
    pe_version => $pe_version
  }
}
