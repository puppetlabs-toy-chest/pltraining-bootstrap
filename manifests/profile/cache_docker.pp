class bootstrap::profile::cache_docker {

  class { 'docker':
    repo_opt => '--setopt=docker.skip_if_unavailable=true'
  }
  docker::image { 'centos:7':}

  # Build the docker containers so they are cached
  include puppetfactory::dockerimages
}

