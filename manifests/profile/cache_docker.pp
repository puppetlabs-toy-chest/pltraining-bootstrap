class bootstrap::profile::cache_docker {

  include docker
  docker::image { 'centos:7':}
  docker::image { 'phusion/baseimage':}

}

