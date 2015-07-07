class bootstrap::profile::ruby {
  # need rubygems to cache rubygems
  package { 'rubygems' :
    ensure  => present,
    require => Class['localrepo'],
    before  => Class['bootstrap::profile::cache_gems'],
  }

  $ruby_aug_package = $::osfamily ? {
    'RedHat' => 'ruby-augeas',
    'Debian' => 'libaugeas-ruby',
  }

  package { 'ruby_augeas_lib':
    ensure  => 'present',
    name    => $ruby_aug_package,
    require => Class['localrepo']
  }
  package { 'puppet-lint':
    ensure   => present,
    provider => gem,
  }
}
