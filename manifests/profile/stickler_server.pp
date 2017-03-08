class bootstrap::profile::stickler_server (
  $gem_dir = '/var/opt/stickler',
) {
  file { $gem_dir:
    ensure => directory,
    before => Service['stickler'],
  }
  $stickler_config_hash = {'gem_dir' => $gem_dir}
  file { '/etc/systemd/system/stickler.service':
    content => epp('bootstrap/learning/stickler.service.epp', $stickler_config_hash),
    notify  => Service['stickler'],
  }
  service { 'stickler':
    ensure => running,
    enable => true,
  }
  exec { '/usr/bin/gem update --system':
    before => Package['stickler'],
  }
  package { 'stickler':
    ensure   => present,
    provider => 'gem',
  }
  $stickler_server_hash = {
    'upstream' => 'http://rubygems.org',
    'server'   => 'http://localhost:6789'
  }
  file { '/root/.gem/stickler':
    content => epp('bootstrap/learning/stickler.epp', $stickler_server_hash),
    notify  => Service['stickler'],
    require => Package['stickler']
  }
}
