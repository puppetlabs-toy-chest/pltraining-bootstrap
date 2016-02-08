class bootstrap::role::puppetfactory {
  include epel
  include localrepo
  include bootstrap
  include pe_repo::platform::el_6_i386
  include pe_repo::platform::el_7_x86_64
  include bootstrap::profile::splash
  include bootstrap::public_key
  include bootstrap::profile::scripts
  include bootstrap::profile::classroom_ssh
}
