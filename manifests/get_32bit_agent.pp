# -------
# Fetch PE and unzip full installer
# Stage agent installer.
# -------

class bootstrap::get_32bit_agent(
  $version   = 'latest',
  $pe_destination = '/root',
  $architecture   = $::architecture,
  $file_cache     = '/vagrant/file_cache'
) {
  $pe_dir        = "puppet-enterprise-${version}-el-${operatingsystemmajrelease}-i386"
  $agent_file     = "${pe_dir}-agent.tar.gz"
  $url            = "https://s3.amazonaws.com/pe-builds/released/${version}"

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
}
