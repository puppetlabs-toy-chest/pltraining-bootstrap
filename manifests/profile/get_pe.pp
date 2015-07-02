# -------
# Fetch PE and unzip full installer
# Stage agent installer.
# -------

class bootstrap::profile::get_pe(
  $version   = '3.8.1',
  $pe_destination = '/root',
  $architecture   = $::architecture,
  $file_cache     = '/vagrant/file_cache'
) {
  $pe_dir        = "puppet-enterprise-${version}-el-${operatingsystemmajrelease}-${architecture}"
  $pe_file        = "${pe_dir}.tar.gz"
  $agent_file     = "${pe_dir}-agent.tar.gz"
  $url            = "https://s3.amazonaws.com/pe-builds/released/${version}"

  Staging::File {
    require => Class['bootstrap::profile::installer_staging']
  }

  # Check if there is a locally cached copy from the build
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
  if file_exists ("${file_cache}/installers/${agent_file}") == 1 {
    staging::file{ $pe_file:
      source => "${file_cache}/installers/${pe_file}",
    }
  }
  else {
    staging::file{ $pe_file:
      source => "${url}/${pe_file}",
    }
  }
  staging::extract{ $pe_file:
    target => "${pe_destination}",
    require => Staging::File[ $pe_file ],
  }

  file { "${pe_destination}/puppet-enterprise":
    ensure => link,
    target => "${pe_destination}/${pe_dir}",
    require => Staging::Extract[ $pe_file ],
  }
}
