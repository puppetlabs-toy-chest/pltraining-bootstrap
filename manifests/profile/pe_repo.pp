class bootstrap::profile::pe_repo {
  # we need to declare these directly so we can specify the $pe_version & $master we need.
  # otherwise it will just use values from the classroom.puppet.com master, which may not be correct.
  class { 'pe_repo':
    master => $fqdn,
  }

  pe_repo::windows { 'windows-x86_64':
    arch          => 'x64',
    agent_version => $aio_agent_version,
    pe_version    => $pe_build,
  }
  pe_repo::debian { 'ubuntu-14.04-amd64':
    agent_version => $aio_agent_version,
    codename      => 'trusty',
    pe_version    => $pe_build,
  }
  pe_repo::el { 'el-7-x86_64':
    agent_version => $aio_agent_version,
    pe_version    => $pe_build,
  }
  pe_repo::el { 'el-6-x86_64':
    agent_version => $aio_agent_version,
    pe_version    => $pe_build,
  }
}