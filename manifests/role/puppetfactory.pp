class bootstrap::role::puppetfactory {
  include boostrap
  include bootstrap::profile::base_ssh
  include bootstrap::profile::get_pe
  include bootstrap::profile::install_pe 
}
