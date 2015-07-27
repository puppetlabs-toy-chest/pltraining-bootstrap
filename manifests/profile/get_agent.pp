# -------
# Cache agent installer where the pe_repo class expects it to be.
# -------
#
# TODO: This should probably be refactored into a defined type so we can cache multiple agent installers
#
class bootstrap::profile::get_agent(
  $pe_version    = '2015.2.0',
  $agent_version = '1.2.2',
  $architecture  = $::architecture,
) {
  case $osfamily {
    'RedHat' : {
      $buildname = "puppet-agent-el-${operatingsystemmajrelease}-${architecture}"
    }
    'Debian' : {
      $buildname = "puppet-agent-debian-${operatingsystemmajrelease}-${architecture}"
    }
    default  : {
      fail('We currently only cache agent installers for RedHat or Debian')
    }
  }
  $staging_dir   = '/opt/puppetlabs/server/data/staging/pe_repo/'
  $agent_file    = "${staging_dir}/${buildname}.tar.gz"
  $url           = "https://pm.puppetlabs.com/puppet-agent/${pe_version}/${agent_version}/repos/${buildname}.tar.gz"

  # TODO: This is tight coupling that should be refactored out
  require bootstrap::profile::installer_staging

  dirtree { $staging_dir:
    path   => $staging_dir,
    ensure => present,
  }

  staging::file { 'cached 32 bit agent installer':
    target => $agent_file,
    source => $url,
  }
}
