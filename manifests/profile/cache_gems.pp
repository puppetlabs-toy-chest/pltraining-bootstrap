class bootstrap::profile::cache_gems (
  $cache_dir = '/var/cache/rubygems',
  $file_cache = '/vagrant/file_cache'
) {
  Bootstrap::Gem {
    cache_dir => "${cache_dir}/gems",
  }

  file { $cache_dir :
    ensure => directory,
  }

  #Check for local build file cache from packer or vagrant
  if file_exists ("${file_cache}/gems") == 1 {
    file { "${cache_dir}/gems" :
      ensure => directory,
      recurse => true,
      source => "${file_cache}/gems",
      require => File[$cache_dir],
    }
  }
  else {
    file { "${cache_dir}/gems" :
      ensure => directory,
      require => File[$cache_dir],
    }
  }

  package { 'builder':
    ensure   => present,
    provider => 'gem',
    require  => Package['rubygems'],
  }

  exec { 'rebuild_gem_cache':
    command     => "gem generate_index -d ${cache_dir}",
    path        => '/opt/puppet/bin:/usr/local/bin:/usr/bin:/bin',
    refreshonly => true,
    require     => Package['builder'],
  }

  file { '/root/.gemrc':
    ensure => file,
    source => 'puppet:///modules/bootstrap/gemrc',
  }

  # Please keep this list alphabetized and organized. It makes it much easier to update.

  # rspec-puppet and family
  bootstrap::gem { 'diff-lcs':                       version => '1.2.5'  }
  bootstrap::gem { 'metaclass':                      version => '0.0.4'  }
  bootstrap::gem { 'mocha':                          version => '1.1.0'  }
  bootstrap::gem { 'puppet-lint':                    version => '1.1.0'  }
  bootstrap::gem { 'puppet-syntax':                  version => '2.0.0'  }
  bootstrap::gem { 'puppetlabs_spec_helper':         version => '0.10.3' }
  bootstrap::gem { 'rspec':                          version => '3.3.0'  }
  bootstrap::gem { 'rspec-core':                     version => '3.3.2'  }
  bootstrap::gem { 'rspec-expectations':             version => '3.3.1'  }
  bootstrap::gem { 'rspec-mocks':                    version => '3.3.2'  }
  bootstrap::gem { 'rspec-puppet':                   version => '2.2.0'  }
  bootstrap::gem { 'rspec-support':                  version => '3.3.0'  }

  # serverspec
  bootstrap::gem { 'net-scp':                        version => '1.2.1'  }
  bootstrap::gem { 'net-ssh':                        version => '2.10.0' }
  bootstrap::gem { 'net-telnet':                     version => '0.1.1'  }
  bootstrap::gem { 'rspec-its':                      version => '1.2.0'  }
  bootstrap::gem { 'sfl':                            version => '2.2'    }
  bootstrap::gem { 'serverspec':                     version => '2.20.0' }
  bootstrap::gem { 'specinfra':                      version => '2.40.0' }

  # carrier-pigeon, for jamtur01/irc report processor
  bootstrap::gem { 'addressable':                    version => '2.3.8'  }
  bootstrap::gem { 'carrier-pigeon':                 version => '0.7.0'  }

  # formatr, for perlform mco reports
  bootstrap::gem { 'formatr':                        version => '1.10.1' }

  # hiera-eyaml
  bootstrap::gem { 'hiera-eyaml':                    version => '2.0.6'  }
  bootstrap::gem { 'highline':                       version => '1.6.21' }
  bootstrap::gem { 'trollop':                        version => '2.0'    }

  # Sinatra and Puppetfactory gems
  bootstrap::gem { 'rack':                           version => '1.4.0'  }
  bootstrap::gem { 'rack-protection':                version => '1.4.0'  }
  bootstrap::gem { 'sinatra':                        version => '1.4.5'  }
  bootstrap::gem { 'tilt':                           version => '1.3.4'  }

  # Learning VM gems
  bootstrap::gem { 'cowsay':                         version => '0.2.0'  }

  # Add bundler to make r10k & ruby happy
  bootstrap::gem { 'bundler':                        version => '1.10.6' }

  # Unidentified dependencies
  bootstrap::gem { 'builder':}
  bootstrap::gem { 'systemu':                        version => '2.5.2'  }


  Bootstrap::Gem <| |> -> File['/root/.gemrc']

}
