define bootstrap::gem(
  $cache_dir = '/var/cache/rubygems/gems',
  $version   = undef,
  $source    = undef,
) {
  if ($version and $source) {
    fail("You can specify only one of source/version for bootstrap::gem[${name}]")
  }

  if $version {
    $gem     = "${name} -v ${version}"
    $pattern = "${name}-${version}*"
  }
  else {
    $gem     = $name
    $pattern = "${name}-[0-9]*\\.[0-9]*\\.[0-9]*"
  }

  if $source {
    $command = "wget ${source}"
  }
  else {
    $command = "gem fetch ${gem}"
  }

  # use unless instead of creates because without a version number, we need a regex
  exec { $command:
    path    => '/opt/puppet/bin:/usr/local/bin:/usr/bin:/bin',
    cwd     => $cache_dir,
    unless  => "find ${cache_dir} -type f -name '${pattern}.gem' | grep '.*'",
    require => File[$cache_dir],
    notify  => Exec['rebuild_gem_cache'],
  }
}
