class bootstrap::profile::replace_factor {
  # Put a script earlier in the path to catch factor-facter typos
  file { '/usr/local/bin/factor':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/bootstrap/factor.sh',
  }
}
