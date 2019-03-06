class bootstrap::profile::learning::local_modules (
  String $module_source_dir = '/var/opt/forge/',
) {

  include wget
  
  $learning_modules = [
    "https://forge.puppet.com/v3/files/puppetlabs-postgresql-5.12.1.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-apt-6.3.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-translate-1.1.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-concat-5.3.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-stdlib-5.2.0.tar.gz",
  ]

  $learning_modules.each | $module | {
    wget::fetch { $module:
      destination => $module_source_dir,
      require => File["${module_source_dir}"],
    }
  }

}
