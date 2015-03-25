# -------
# Fetch and unzip 32bit agent installer
# -------

class bootstrap::get_32bit_agent(
  $version   = 'latest',
  $architecture   = $::architecture,
  $file_cache     = '/vagrant/file_cache'
) {
  $puppet_dir   = '/opt/puppet'
  $repo_dir     = "${puppet_dir}/packages"
  $public_dir   = "${repo_dir}/public"
  $version_dir  = "${public_dir}/${version}"
  $agent_dir    = "puppet-enterprise-${version}-el-${operatingsystemmajrelease}-i386-agent"
  $agent_file   = "${agent_dir}.tar.gz"
  $url          = "https://s3.amazonaws.com/pe-builds/released/${version}"

  file { [$puppet_dir,$repo_dir,$public_dir,$version_dir]:
    ensure => directory
  }
  staging::deploy { $agent_file:
    source  => "${url}/${agent_file}",
    target  => $public_dir,
    creates => "${public_dir}/${agent_dir}",
    require => File[$public_dir]
  }
  #our nice symlink to make the .repo files happy
  file { "${version_dir}/el-${operatingsystemmajrelease}-i386":
    ensure  => link,
    target  => "${public_dir}/${agent_dir}/agent_packages/${installer_build}",
    require => [Staging::Deploy[$agent_file],File[$version_dir]],
  }
}
