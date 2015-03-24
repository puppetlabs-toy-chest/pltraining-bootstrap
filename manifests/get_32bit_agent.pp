# -------
# Fetch and unzip 32bit agent installer
# -------

class bootstrap::get_32bit_agent(
  $version   = 'latest',
  $repo_dir = '/opt/puppet/packages/',
  $architecture   = $::architecture,
  $file_cache     = '/vagrant/file_cache'
) {
  $agent_dir        = "puppet-enterprise-${version}-el-${operatingsystemmajrelease}-i386-agent"
  $agent_file     = "${agent_dir}.tar.gz"
  $public_dir     = "${repo_dir}/public"
  $url            = "https://s3.amazonaws.com/pe-builds/released/${version}"

  file { $repo_dir:
    ensure => directory,
  }
  file { "${public_dir}/":
    ensure => directory,
  }
  file { "${public_dir}/${version}":
    ensure => directory,
  }
  staging::deploy { $agent_file:
    source  => "${url}/${agent_file}",
    target  => "${public_dir}/",
    creates => "${public_dir}/${agent_dir}",
    require => File["${public_dir}/"]
  }
  #our nice symlink to make the .repo files happy
  file { "${public_dir}/${version}/el-${operatingsystemmajrelease}-i386":
    ensure  => link,
    target  => "${public_dir}/${agent_dir}/agent_packages/${installer_build}",
    require => [Staging::Deploy[$agent_file],File["${public_dir}/${version}"]],
  }
}
