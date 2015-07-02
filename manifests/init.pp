class bootstrap {
  include bootstrap::base
  include bootstrap::ruby
  include bootstrap::cache_modules
  include bootstrap::cache_gems
  include userprefs::defaults
  include bootstrap::splash
  include bootstrap::yum
  include bootstrap::ssh
  include bootstrap::network
}
