class bootstrap::role::training {
  include epel
  include localrepo
  include bootstrap
  include bootstrap::profile::splash
  include bootstrap::profile::installer_staging
  include bootstrap::profile::cache_wordpress
  include bootstrap::profile::scripts
  include bootstrap::profile::classroom_ssh
  include bootstrap::profile::get_32bit_agent
  include bootstrap::profile::get_pe
}
