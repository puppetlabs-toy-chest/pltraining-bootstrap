class bootstrap::profile::learning::local_modules (
  String $module_source_dir = '/var/opt/forge/',
) {

  include wget
  
  $learning_modules = [
    "https://forge.puppet.com/v3/files/puppetlabs-stdlib-4.20.0.tar.gz",
    "https://forge.puppet.com/v3/files/puppetlabs-concat-2.2.1.tar.gz",
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
