class bootstrap::profile::cache_docker {

  include docker
  docker::image { 'maci0/systemd':}
  docker::image { 'phusion/baseimage':}

}

