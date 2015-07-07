class bootstrap::profile::learning_splash {
  class {'bootstrap::profile::splash':
    # Note: the $IP_ADDRESS string is a variable determined at boot time by rc.local
    login_message => 'Quest Guide: http://$IP_ADDRESS'
  }
}
