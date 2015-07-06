class bootstrap::profile::classroom_ssh {

  # This script generates the initial root SSH key for the fundamentals git workflow
  file { '/root/.ssh_keygen.sh':
    ensure => file,
    source => 'puppet:///modules/bootstrap/ssh_keygen.sh',
    mode   => 0755,
  }
  # Disable GSSAPIAuth for classroom VMs.
  augeas { "GSSAPI_disable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set GSSAPIAuthentication no',
    require => Package['ruby_augeas_lib'],
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
