class bootstrap::profile::cache_rpms (
  $build = 'master', # used when generating package lists
) {
  $repo_base = '/var/yum'
  $repo_dir  = "${repo_base}/mirror"
  $pkglist   = '/etc/yum/repotrack.pkg'
  $custompkg = template('bootstrap/custom_packages.erb')

  file { [$repo_base,$repo_dir]:
    ensure => directory,
    before => Exec['cache packages'],
  }
  package { ['createrepo', 'yum-utils']:
    ensure => present,
  }

  file { $pkglist:
    ensure  => file,
    content => template('bootstrap/packages.erb'),
    notify  => Exec['cache packages'],
  }
  exec {'cache packages':
    command     => "repotrack -p ${repo_dir} -r base -r updates -r epel \$(cat ${pkglist})",
    path        => '/bin',
    timeout     => '1200',
    logoutput   => false,
    refreshonly => true,
    require     => Yumrepo['epel'],
    notify      => Exec['createrepo'],
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
    descr    => 'Packages mirrored to simplify classroom exercises',
    baseurl  => "file://${repo_dir}",
    enabled  => 1,
    gpgcheck => 0,
    priority => 1,
  }
}
