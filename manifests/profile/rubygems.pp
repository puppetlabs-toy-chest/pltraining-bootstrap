class bootstrap::profile::rubygems {
  assert_private('This class should not be called directly')

  # These are required by rubygems compiling native code
  package { ['cmake3', 'cmake', 'gcc', 'zlib', 'zlib-devel']:
    ensure => present,
  }

  # these are used for various scripts
  package { ['puppetdb-ruby', 'colorize', 'puppetclassify']:
    ensure   => present,
    provider => puppet_gem,
  }
}

