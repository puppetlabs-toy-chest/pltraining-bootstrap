class bootstrap::role::student {
  include localrepo
  include bootstrap
  include bootstrap::profile::network
  include bootstrap::profile::splash
  include bootstrap::profile::classroom_ssh
  include bootstrap::public_key
}
