class bootstrap::role::master {
  include bootstrap
  include bootstrap::profile::ruby
  include bootstrap::profile::pe_master
  include bootstrap::profile::cache_rpms
  include bootstrap::profile::network
  include bootstrap::profile::cache_modules
  include userprefs::defaults
  include bootstrap::profile::pe_repo
  include bootstrap::profile::splash
  include bootstrap::profile::pe_tweaks
  include bootstrap::profile::disable_selinux
  include bootstrap::public_key
  include bootstrap::profile::cache_docker
  include bootstrap::profile::pdf_stack
  include bootstrap::profile::rubygems
  include bootstrap::profile::cache_gitea
  include bootstrap::profile::cache_gems
  include bootstrap::profile::courseware
  include bootstrap::profile::classroom

  # Ensure that the Ruby gems are cached on the master before
  # caching the Docker image. A null mount needs to be in place
  # so the /var/cache/rubygems directory appears inside the Docker
  # image to facilitate offline gem installation for rspec-puppet
  # and serverspec exercises in the Practitioner course
  Class['bootstrap::profile::cache_gems'] ->
    Class['bootstrap::profile::cache_docker']
}
