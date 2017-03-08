define bootstrap::profile::stickler_clone_gem (
  String $version, 
  String $gem_dir = '/var/opt/stickler'
) {

  if $version {
    $version_arg = " --gem-version ${version} "
  } else {
    $version_arg = ''
  }

  exec { "stickler mirror ${version_arg} ${title} | grep 'OK'":
    path        => ['/usr/bin', '/usr/local/bin'],
    environment => ['HOME=/root'],
    unless      => "/usr/local/bin/stickler list | /bin/grep '${title}'",
    logoutput   => on_failure,
    require     => Class['bootstrap::profile::stickler_server'],
  }

}
