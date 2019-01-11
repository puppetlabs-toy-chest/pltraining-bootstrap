class bootstrap::profile::ruby (
  $install_bundler = false,
) {
  # need rubygems to cache rubygems
  package { 'rubygems' :
    ensure  => present,
    require => Yumrepo['local'],
    before  => Class['bootstrap::profile::cache_gems'],
  }

  if $install_bundler {
    package { 'bundler':
      ensure   => '1.17.3',
      provider => gem,
    }
  }

  package { 'ruby-augeas':
    ensure  => 'present',
    require => Yumrepo['epel'],
  }
  package { 'puppet-lint':
    ensure   => present,
    provider => gem,
  }
}
