class bootstrap::role::puppetfactory {
  include boostrap
  include bootstrap::profile::installer_staging
  include bootstrap::profile::scripts
  include bootstrap::profile::classroom_ssh
  include bootstrap::profile::get_pe
  include bootstrap::profile::install_pe 
}
