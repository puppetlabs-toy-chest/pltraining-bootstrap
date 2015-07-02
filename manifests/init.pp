class bootstrap {
  include bootstrap::profile::base
  include bootstrap::profile::ruby
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include userprefs::profile::defaults
  include bootstrap::profile::splash
  include bootstrap::profile::yum
  include bootstrap::profile::ssh
  include bootstrap::profile::network
}
