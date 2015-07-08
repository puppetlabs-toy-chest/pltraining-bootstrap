class bootstrap::role::lms {
  include epel
  include localrepo
  include lms::lab_deps
  include lms::lab_repo
  include lms::course_selector
  include lms::install_pe
  include userprefs::defaults
  include bootstrap::profile::yum
  include bootstrap::profile::base
  include bootstrap::profile::ruby
  include bootstrap::profile::lms_get_pe
  include bootstrap::profile::network
  include bootstrap::profile::lms_base
  include bootstrap::profile::cache_gems
  include bootstrap::profile::lms_defaults
  include bootstrap::profile::classroom_ssh
  include bootstrap::profile::cache_modules
  include bootstrap::profile::installer_staging
}
