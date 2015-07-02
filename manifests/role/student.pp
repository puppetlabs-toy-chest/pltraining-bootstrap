class bootstrap::role::student {
  include bootstrap::profile::yum
  include bootstrap::profile::base_ssh
  include bootstrap::profile::network
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include bootstrap::profile::ruby
}
