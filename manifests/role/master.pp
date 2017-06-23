class bootstrap::role::master {
  include bootstrap
  include bootstrap::profile::ruby
  include bootstrap::profile::cache_rpms
  include bootstrap::profile::network
  include bootstrap::profile::cache_modules
  include userprefs::defaults
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
  include bootstrap::profile::rubygems
  include bootstrap::profile::cache_gitea
  include bootstrap::profile::deployer
  include bootstrap::profile::cache_gems
  include bootstrap::profile::pe_tuning

  # Ensure that the Ruby gems are cached on the master before
  # caching the Docker image. A null mount needs to be in place
  # so the /var/cache/rubygems directory appears inside the Docker
  # image to facilitate offline gem installation for rspec-puppet
  # and serverspec exercises in the Practitioner course
  Class['bootstrap::profile::cache_gems'] ->
    Class['bootstrap::profile::cache_docker']
}
