class bootstrap::role::student {
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include bootstrap::profile::ruby
}
