class bootstrap::role::student {
  include epel
  include localrepo
  include boostrap
  include bootstrap::profile::splash
  include bootstrap::profile::classroom_ssh
}
