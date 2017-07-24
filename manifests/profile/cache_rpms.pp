class bootstrap::profile::cache_rpms (
  $build = 'master', # used when generating package lists
) {
  $pkglist   = template('bootstrap/packages.erb')
  $custompkg = template('bootstrap/custom_packages.erb')
  $repo_base = '/var/yum'
  $repo_dir  = "${repo_base}/mirror"

  file { [$repo_base,$repo_dir]:
    ensure => directory,
    before => Exec['cache packages'],
  }
  package { 'createrepo':
    ensure => present,
  }
  exec {'cache packages':
    command   => "repotrack -p ${repo_dir} ${pkglist}",
    path      => '/bin',
    timeout   => '600',
    logoutput => false,
    require   => Yumrepo['epel'],
    notify    => Exec['createrepo'],
  }

  $custompkg.split("\n").each |$url| {
    archive { "${repo_dir}/${basename($url)}":
      source => $url,
      notify => Exec['createrepo'],
    }
  }

  exec { 'createrepo':
    command     => '/bin/createrepo .',
    cwd         => $repo_dir,
    logoutput   => true,
    refreshonly => true,
    require     => Package['createrepo'],
    before      => Yumrepo['local'],
  }
  yumrepo { 'local':
    name     => 'local',
    baseurl  => "file://${repo_dir}",
    enabled  => 1,
    gpgcheck => 0,
    priority => 1,
  }
}
