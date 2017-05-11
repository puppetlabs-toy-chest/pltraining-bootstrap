class bootstrap::profile::cache_docker {

  class { 'docker':
    repo_opt => '--setopt=docker.skip_if_unavailable=true'
  }
  contain docker
  
  # Build the centos docker container so it is cached
  class { 'puppetfactory::centosimage':
    master_address => 'master.puppetlabs.vm'
  }
  contain puppetfactory::centosimage
}

