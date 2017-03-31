class bootstrap::profile::rubygems {
  assert_private('This class should not be called directly')

  include epel
  # These are required by rubygems compiling native code
  package { ['cmake3', 'gcc', 'zlib', 'zlib-devel']:
    ensure => present,
    require => Class['epel'],
  }

  # these are used for various scripts
  package { ['puppetdb-ruby', 'colorize', 'puppetclassify']:
    ensure   => present,
    provider => puppet_gem,
  }
}

