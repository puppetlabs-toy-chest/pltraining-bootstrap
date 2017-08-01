class bootstrap::profile::rubygems {
  assert_private('This class should not be called directly')

  include epel
  # These are required by rubygems compiling native code
  package { ['cmake3', 'cmake', 'gcc', 'gcc-c++', 'zlib', 'zlib-devel', 'ruby-devel' ]:
    ensure => present,
    require => Class['epel'],
    before  => Package['puppetdb-ruby', 'colorize', 'puppetclassify', 'nokogiri'],
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
}

