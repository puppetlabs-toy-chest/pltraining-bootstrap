class bootstrap::role::training {
  include bootstrap
  include bootstrap::profile::training_ssh
  include bootstrap::profile::get_32bit_agent
  include bootstrap::profile::get_pe
}
