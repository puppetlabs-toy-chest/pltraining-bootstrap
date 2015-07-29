# -------
# Cache agent installers where the pe_repo class expects them to be.
# -------
#
define bootstrap::cached_agent (
  $pe_version    = $bootstrap::params::pe_version,
  $agent_version = $bootstrap::params::agent_version,
  $platform      = $::osfamily,
  $release       = $::operatingsystemmajrelease,
  $architecture  = $::architecture,
) {
  validate_string($pe_version)
  validate_string($agent_version)
  validate_string($platform)
  validate_string($release)
  validate_string($architecture)

  case $platform {
    'RedHat' : {
      $buildname = "puppet-agent-el-${release}-${architecture}.tar.gz"
    }
    'Debian', 'EL', 'SLES', 'Solaris', 'Ubuntu': {
      $lc_platform = downcase($platform)
      $buildname = "puppet-agent-${lc_platform}-${release}-${architecture}.tar.gz"
    }
    'OSX' : {
      $buildname = "puppet-agent-osx-${release}.tar.gz"
    }
    'Windows' : {
      $buildname =  $architecture ? {
        'x86_64' => "puppet-agent-x64.msi",
        'i386'   => "puppet-agent-${architecture}.msi",
      }
    }
    default  : {
      fail("There is currently no agent installer available for ${platform}")
    }
  }

  case $platform {
    # platforms that download directly to the pe_repo directory instead of staging
    'Windows' : {
      $staging_dir = "/opt/puppetlabs/server/data/packages/public/${pe_version}/windows-${architecture}"
      $url         = "https://pm.puppetlabs.com/puppet-agent/${pe_version}/${agent_version}/repos/windows/${buildname}"
    }
    default  : {
      $staging_dir = '/opt/puppetlabs/server/data/staging/pe_repo'
      $url         = "https://pm.puppetlabs.com/puppet-agent/${pe_version}/${agent_version}/repos/${buildname}"
    }
  }

  $agent_file = "${staging_dir}/${buildname}"

  if ! defined(Dirtree[$staging_dir]) {
    dirtree { $staging_dir:
      path    => $staging_dir,
      ensure  => present,
      parents => true,
    }
  }

  staging::file { "cached agent installer: ${buildname}":
    target => $agent_file,
    source => $url,
  }
}
