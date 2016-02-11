class bootstrap::role::student {
  include epel
  include localrepo
  include bootstrap
  include bootstrap::profile::splash
  include bootstrap::profile::classroom_ssh
}
