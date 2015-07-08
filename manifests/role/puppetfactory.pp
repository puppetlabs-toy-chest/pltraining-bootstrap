class bootstrap::role::puppetfactory {
  include epel
  include localrepo
  include bootstrap
  include bootstrap::profile::splash
  include bootstrap::profile::installer_staging
  include bootstrap::profile::scripts
  include bootstrap::profile::classroom_ssh
  include bootstrap::profile::get_pe
  include bootstrap::profile::install_pe 
}
