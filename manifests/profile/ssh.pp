class bootstrap::profile::ssh {

  # This script generates the initial root SSH key for the fundamentals git workflow
  if $::hostname =~ /train/ {
    file { '/root/.ssh_keygen.sh':
      ensure => file,
      source => 'puppet:///modules/bootstrap/ssh_keygen.sh',
      mode   => 0755,
    }
    # Disable GSSAPIAuth for training VM.
    # The learning VM has a quest that relates to this, so leave
    # it enabled for the LVM.
    augeas { "GSSAPI_disable":
      context => '/files/etc/ssh/sshd_config',
      changes => 'set GSSAPIAuthentication no',
    }

  }
  if $::hostname =~ /learn/ {
    # Enable GSSAPIAuth for learning VM.
    # The learning VM has a quest that relates to this, so leave
    # it enabled for the LVM.
    augeas { "GSSAPI_enable":
      context => '/files/etc/ssh/sshd_config',
      changes => 'set GSSAPIAuthentication yes',
    }

  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
