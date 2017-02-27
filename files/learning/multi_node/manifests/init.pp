class multi_node {
  include docker
  docker::image { 'phusion/baseimage:0.9.18':}
  docker::run { "webserver":
    image            => 'phusion/baseimage:0.9.18',
    command          => '/sbin/my_init',
    hostname         => "webserver.${::fqdn}",
    extra_parameters => "--add-host puppet:172.17.0.1 --add-host ${::fqdn}:172.17.0.1",
    volumes          => ['/etc/docker/ssl_dir:/etc/puppetlabs/puppet/ssl'],
    ports            => ['10080:80'],
    links            => ['database:database'],
    depends          => ['database'],
    require          => Docker::Run['database'],
  }
  docker::run { "database":
    image            => 'phusion/baseimage:0.9.18',
    command          => '/sbin/my_init',
    hostname         => "database.${::fqdn}",
    extra_parameters => "--add-host puppet:172.17.0.1 --add-host ${::fqdn}:172.17.0.1",
    volumes          => ['/etc/docker/ssl_dir:/etc/puppetlabs/puppet/ssl'],
    ports            => ['23306:3306'],
  }
}
