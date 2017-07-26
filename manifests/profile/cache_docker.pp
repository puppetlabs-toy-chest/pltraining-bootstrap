class bootstrap::profile::cache_docker {

  class { 'docker':
    repo_opt => '--setopt=docker.skip_if_unavailable=true'
  }
  contain docker

  # Build the centos docker container so it is cached
  class { 'dockeragent':
    image_name => 'centosagent',
  }

}

