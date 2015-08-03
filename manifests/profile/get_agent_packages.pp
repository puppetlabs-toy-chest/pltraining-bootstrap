# -------
# Fetch agent installers for the classroom
# -------

class bootstrap::profile::get_agent_packages {
  include bootstrap::params

  bootstrap::cached_agent { '32 bit RedHat':
    platform     => 'RedHat',
    architecture => 'i386',
  }
  
  bootstrap::cached_agent { '64 bit RedHat':
    platform     => 'RedHat',
    architecture => 'x86_64',
  }

  bootstrap::cached_agent { '64 bit Ubuntu':
    platform     => 'Ubuntu',
    release      => '14.04',
    architecture => 'amd64',
  }

  bootstrap::cached_agent { '64 bit Windows':
    platform     => 'Windows',
    architecture => 'x86_64',
  }

}
