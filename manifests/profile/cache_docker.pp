class bootstrap::profile::cache_docker {

  class { 'docker':
    repo_opt => '--setopt=docker.skip_if_unavailable=true'
  }
  docker::image { 'maci0/systemd':} # TODO: remove when releasing v5.13
  docker::image { 'centos:7':}
  docker::image { 'phusion/baseimage':}
}

