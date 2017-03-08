class bootstrap {
  include bootstrap::profile::base
  include bootstrap::profile::cache_gems
  include bootstrap::profile::yum
  include bootstrap::profile::scripts
  include bootstrap::profile::replace_factor
}
