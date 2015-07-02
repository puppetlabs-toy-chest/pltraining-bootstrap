class bootstrap::role::puppetfactory {
  include boostrap
  include bootstrap::profile::scripts
  include bootstrap::profile::base_ssh
  include bootstrap::profile::get_pe
  include bootstrap::profile::install_pe 
}
