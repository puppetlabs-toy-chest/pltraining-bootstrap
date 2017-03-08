define bootstrap::profile::stickler_clone_gem (
  String $version, 
  String $gem_dir = '/var/opt/stickler'
) {

  if $version {
    $version_arg = " --gem-version ${version} "
  } else {
    $version_arg = ''
  }

  exec { "/usr/local/bin/stickler mirror ${version_arg} ${title}":
    unless  => "/usr/local/bin/stickler list | /bin/grep '${title}'",
    require => Class['bootstrap::profile::stickler_server'],
  }

}
