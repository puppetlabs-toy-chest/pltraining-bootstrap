class bootstrap::profile::scripts {
  # Populate the VM with our helper scripts.
  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
  file {'/usr/local/bin':
    ensure  => directory,
    recurse => true,
    replace => false,
    source  => 'puppet:///modules/bootstrap/scripts/classroom',
  }

  file { '/bin/passwd.orig':
    ensure  => file,
    mode    => '4755',
    replace => false,
    source  => '/bin/passwd',
  }

  file { '/sbin/chpasswd.orig':
    ensure  => file,
    mode    => '4755',
    replace => false,
    source  => '/sbin/chpasswd',
  }

  file { ['/bin/passwd', '/sbin/chpasswd']:
    ensure  => link,
    target  => '/usr/local/bin/reset_password.rb',
  }

}
