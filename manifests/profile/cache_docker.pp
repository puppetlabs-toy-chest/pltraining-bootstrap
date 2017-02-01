class bootstrap::profile::cache_docker {

  include docker
  docker::image { 'maci0/systemd':} # TODO: remove when releasing v5.13
  docker::image { 'centos:7':}
  docker::image { 'phusion/baseimage':}

}

