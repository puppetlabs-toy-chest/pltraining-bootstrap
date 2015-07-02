class bootstrap::profile::learning_ssh {

  augeas { "GSSAPI_enable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set GSSAPIAuthentication yes',
    require => Package['ruby_augeas_lib'],
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
