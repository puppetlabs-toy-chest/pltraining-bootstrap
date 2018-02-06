class bootstrap::profile::rubygems {
  assert_private('This class should not be called directly')

  include epel
  # These are required by rubygems compiling native code
  package { ['cmake3', 'cmake', 'gcc', 'zlib', 'zlib-devel']:
    ensure => present,
    require => Class['epel'],
    before  => Package['puppetdb-ruby', 'colorize', 'puppetclassify', 'nokogiri', 'public_suffix'],
  }

  # these are used for various scripts
  package { ['puppetdb-ruby', 'colorize', 'puppetclassify']:
    ensure   => present,
    provider => puppet_gem,
  }
  package { 'nokogiri':
    ensure   => '1.6.8.1',
    provider => gem,
  }
  package { 'public_suffix':
    ensure   => '2.0.5',
    provider => gem,
  }
  package { 'rack-test':
    ensure   => '0.6.3',
    provider => gem,
  }
  package { 'rack':
    ensure   => '1.6.4',
    provider => gem,
    before   => Package['rack-test'],
  }
  package { 'rest-client':
    ensure => '2.0.2',
    provider => gem,
  }
}
