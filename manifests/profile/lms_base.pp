class bootstrap::profile::lms_base {
  file { '/etc/bash.bash_logout':
    ensure => present,
    source => 'puppet:///modules/bootstrap/lms/bash.bash_logout',
  }
  file {'/etc/profile.d/profile.sh':
    ensure => present,
    mode   => 755,
    source => 'puppet:///modules/bootstrap/lms/profile.sh',
  }
}
