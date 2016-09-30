class bootstrap::profile::nginx_proxy {
  include nginx

  nginx::resource::vhost { $::ipaddress:
    listen_port => '80',
    proxy            => 'http://localhost:8080/guacamole/',
    proxy_set_header => [
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'Host $http_host',
      'X-NgingX-Proxy true',
      'Upgrade $http_upgrade',
      'Connection "Upgrade"'
    ],
  }
}
