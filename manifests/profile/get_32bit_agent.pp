# -------
# Fetch and unzip 32bit agent installer
# Pinned to el6
# -------

class bootstrap::profile::get_32bit_agent(
  $version        = '2015.2',
  $agent_version  = '1.2.2',
  $architecture   = $::architecture,
  $file_cache     = '/vagrant/file_cache'
) {
  $puppet_dir   = '/opt/puppetlabs'
  $data_dir     = "${puppet_dir}/data"
  $repo_dir     = "${data_dir}/packages"
  $public_dir   = "${repo_dir}/public"
  $version_dir  = "${public_dir}/${version}"
  $agent_arch   = "el-6-i386"
  $agent_dir    = "puppet-agent-${agent_arch}"
  $agent_file   = "${agent_dir}.tar.gz"
  $url          = "https://s3.amazonaws.com/puppet-agents/${version}/puppet-agent/${agent_version}/repos/"

  Staging::File {
    require => Class['bootstrap::profile::installer_staging']
  }
  
  if file_exists ("${file_cache}/installers/${agent_file}") == 1 {
    staging::file{ $agent_file:
      source => "${file_cache}/installers/${agent_file}",
    }
  }
  else {
    staging::file{ $agent_file:
      source => "${url}/${agent_file}",
    }
  }

  file { [$puppet_dir,$data_dir,$repo_dir,$public_dir,$version_dir]:
    ensure => directory
  }
  staging::extract { $agent_file:
    target  => $public_dir,
    creates => "${public_dir}/${agent_dir}",
    require => [File[$public_dir],Staging::File[$agent_file]]
  }
  #our nice symlink to make the .repo files happy
  file { "${version_dir}/el-6-i386":
    ensure  => link,
    target  => "${public_dir}/${agent_dir}/agent_packages/${installer_build}",
    require => [Staging::Extract[$agent_file],File[$version_dir]],
  }
}
