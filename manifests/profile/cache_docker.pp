class bootstrap::profile::cache_docker {

  class { 'docker':
    repo_opt => '--setopt=docker.skip_if_unavailable=true'
  }
  contain docker

  # Build the centos docker container so it is cached
  file { '/etc/docker/centosagent/':
    ensure => directory,
  }
  file { '/etc/docker/centosagent/Dockerfile':
    ensure  => file,
    content => 'FROM agent',
  }
  include dockeragent
  docker::image { 'centosagent':
    ensure      => present,
    docker_file => '/etc/docker/centosagent/Dockerfile',
  }

}
