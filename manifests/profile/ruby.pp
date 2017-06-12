class bootstrap::profile::ruby (
  $install_bundler = false,
) {
  # need rubygems to cache rubygems
  package { 'rubygems' :
    ensure  => present,
    require => Class['localrepo'],
    before  => Class['bootstrap::profile::cache_gems'],
  }

  if $install_bundler {
    package { 'bundler':
      ensure   => present,
      provider => gem,
    }
  }

  $ruby_aug_package = $::osfamily ? {
    'RedHat' => 'ruby-augeas',
    'Debian' => 'libaugeas-ruby',
  }

  package { 'ruby_augeas_lib':
    ensure  => 'present',
    name    => $ruby_aug_package,
  }
  package { 'puppet-lint':
    ensure   => present,
    provider => gem,
  }
}
