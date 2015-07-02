class bootstrap::profile::base_ssh {

  augeas { "GSSAPI_enable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set GSSAPIAuthentication yes',
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
