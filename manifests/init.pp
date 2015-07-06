class bootstrap {
  include bootstrap::profile::base
  include bootstrap::profile::ruby
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include userprefs::defaults
  include bootstrap::profile::yum
  include bootstrap::profile::network
}
