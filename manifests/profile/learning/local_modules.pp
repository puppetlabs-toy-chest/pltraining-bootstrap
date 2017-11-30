class bootstrap::profile::learning::local_modules (
  String $module_source_dir = '/var/opt/forge/',
) {

  include wget
  
  $learning_modules = [
    "https://forge.puppet.com/v3/files/puppet-staging-2.2.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-stdlib-4.7.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-stdlib-4.15.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-mysql-3.10.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-ntp-6.0.0.tar.gz",
    "https://forge.puppet.com/v3/files/dwerder-graphite-5.16.1.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-apache-1.11.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-concat-2.2.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-postgresql-4.9.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-apt-2.4.0.tar.gz",
  ]

  $learning_modules.each | $module | {
    wget::fetch { $module:
      destination => $module_source_dir,
      require => File["${module_source_dir}"],
    }
  }

}
