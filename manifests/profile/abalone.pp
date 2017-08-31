class bootstrap::profile::abalone {
  
  class { 'abalone':
    port => '9091',
    bannerfile => '/etc/issue',
    require  => Class['bootstrap::profile::rubygems'],
  }

  file_line { 'pam_securetty':
    path  => '/etc/pam.d/login',
    line  => '#auth [user_unknown=ignore success=ok ignore default=bad] pam_security.so',
    match => 'pam_securetty.so$',
  }

} 
