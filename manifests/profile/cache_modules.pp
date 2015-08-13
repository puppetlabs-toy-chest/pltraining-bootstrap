class bootstrap::profile::cache_modules(
  $cache_dir = '/usr/src/forge',
) {
  Bootstrap::Forge {
    cache_dir => $cache_dir,
  }

  file { $cache_dir:
    ensure => directory,
  }

  # These are the modules needed by the Fundamentals course

  # This is a temporary kludge as we transition from ripienaar-concat to puppetlabs
  # TODO: revisit this regularly and dump it when PE ships with this and all modules
  #       we use get updated to use this.
  bootstrap::forge { 'badgerious-windows_env':          version => '2.2.1'}
  bootstrap::forge { 'chocolatey-chocolatey':           version => '0.5.3'}
  bootstrap::forge { 'domcleal-augeasproviders':        version => '1.2.1'}
  bootstrap::forge { 'dwerder-graphite': }
  bootstrap::forge { 'garethr-docker':                  version => '4.1.0'}
  bootstrap::forge { 'hunner-charybdis':                version => '1.0.0'}
  bootstrap::forge { 'hunner-wordpress':                version => '0.6.0'}
  bootstrap::forge { 'jamtur01-irc':                    version => '0.0.7'}
  bootstrap::forge { 'jordan-fileshare':                version => '1.1.1'}
  bootstrap::forge { 'jriviere-windows_ad':             version => '0.2.0'}
  bootstrap::forge { 'nanliu-staging':                  version => '1.0.3'}
  bootstrap::forge { 'opentable-download_file':         version => '1.1.0'}
  bootstrap::forge { 'opentable-windowsfeature':        version => '1.0.0'}
  bootstrap::forge { 'pltraining-classroom':            version => '1.3.3'}
  bootstrap::forge { 'pltraining-dirtree':              version => '0.2.2'}
  bootstrap::forge { 'pltraining-rbac':                 version => '0.0.4'}
  bootstrap::forge { 'pltraining-userprefs':}
  bootstrap::forge { 'puppetlabs-acl':                  version => '1.1.1'}
  bootstrap::forge { 'puppetlabs-apache':               version => '1.6.0'}
  bootstrap::forge { 'puppetlabs-concat':               version => '1.2.4'}
  bootstrap::forge { 'puppetlabs-git':                  version => '0.4.0'}
  bootstrap::forge { 'puppetlabs-haproxy':              version => '1.3.0'}
  bootstrap::forge { 'puppetlabs-inifile':              version => '1.4.1'}
  bootstrap::forge { 'puppetlabs-mysql':                version => '3.5.0'}
  bootstrap::forge { 'puppetlabs-ntp':                  version => '4.1.0'}
  bootstrap::forge { 'puppetlabs-pe_gem':               version => '0.1.1'}
  bootstrap::forge { 'puppetlabs-pe_puppetserver_gem':  version => '0.0.1'}
  bootstrap::forge { 'puppetlabs/puppetserver_gem':     version => '0.1.0'}
  bootstrap::forge { 'puppetlabs-reboot':               version => '0.1.9'}
  bootstrap::forge { 'puppetlabs-registry':             version => '1.1.0'}
  bootstrap::forge { 'puppetlabs-stdlib':               version => '4.7.0'}
  bootstrap::forge { 'puppetlabs-vcsrepo':              version => '1.3.0'}
  bootstrap::forge { 'razorsedge-vmwaretools':          version => '5.0.1'}
  bootstrap::forge { 'stahnma-epel':                    version => '1.0.2'}
  bootstrap::forge { 'thias-vsftpd':                    version => '0.2.1'}
  bootstrap::forge { 'zack-exports':                    version => '0.0.4'}
  bootstrap::forge { 'zack-r10k':                       version => '3.0.0'}
}
