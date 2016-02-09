class bootstrap::role::master {
  include epel
  include localrepo
  include bootstrap
  include pe_repo::platform::el_6_i386
  include pe_repo::platform::el_7_x86_64
  include pe_repo::platform::ubuntu_1404_amd64
  include bootstrap::profile::splash
  include bootstrap::public_key
  include bootstrap::profile::scripts
  include bootstrap::profile::classroom_ssh
}
