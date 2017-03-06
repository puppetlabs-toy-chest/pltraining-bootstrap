define bootstrap::profile::stickler_clone_gem (
  String $gem,
  String $version, 
  String $gem_dir = '/var/opt/stickler'
) {

  if $version {
    $version_arg = " --gem-version ${version} "
  } else {
    $version_arg = ''
  }

  exec { "/usr/bin/stickler mirror ${version_arg} ${gem}":
    destination => "${pypi_pkg_dir}/${basename}",
    require     => Class['bootstrap::profile::stickler_server']
  }

}
