class bootstrap::role::student {
  include epel
  include userprefs::defaults
  include localrepo
  include bootstrap::profile::scripts
  include bootstrap::profile::splash
  include bootstrap::profile::base
  include bootstrap::profile::yum
  include bootstrap::profile::classroom_ssh
  include bootstrap::profile::network
  include bootstrap::profile::cache_modules
  include bootstrap::profile::cache_gems
  include bootstrap::profile::ruby
}
