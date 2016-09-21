class bootstrap::role::master {
  include localrepo
  include bootstrap
  include bootstrap::profile::network
  include pe_repo::platform::el_6_i386
  include pe_repo::platform::el_7_x86_64
  include pe_repo::platform::ubuntu_1404_amd64
  include pe_repo::platform::windows_x86_64
  include bootstrap::profile::splash
  include bootstrap::profile::pe_tweaks
  include bootstrap::profile::disable_selinux
  include bootstrap::public_key
  include bootstrap::profile::cache_docker
  include bootstrap::profile::pdf_stack
}
