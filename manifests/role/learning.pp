class bootstrap::role::learning {
  include bootstrap
  include bootstrap::profile::get_pe
  include bootstrap::profile::install_pe
  include bootstrap::profile::set_defaults
}
