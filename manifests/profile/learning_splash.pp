class bootstrap::profile::learning_splash {
  class {'bootstrap::profiles::learning_splash':
    login_message => 'To view the quest guide, go to http://<YOUR IP>'
  }
}
