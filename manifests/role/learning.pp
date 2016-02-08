class bootstrap::role::learning {
  include epel
  include localrepo
  include bootstrap
  include lms::course_selector
  include lms::lab_repo
  include bootstrap::profile::quest_content
  include bootstrap::profile::learning_ssh
  include bootstrap::profile::set_defaults
  include bootstrap::profile::learning_splash
  include bootstrap::profile::replace_factor
}
