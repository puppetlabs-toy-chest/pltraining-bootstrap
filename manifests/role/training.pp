class bootstrap::role::training {
  include bootstrap
  include bootstrap::profile::scripts
  include bootstrap::profile::classroom_ssh
  include bootstrap::profile::get_32bit_agent
  include bootstrap::profile::get_pe
}
