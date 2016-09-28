class bootstrap::profile::nginx_proxy {
  include nginx
  
  nginx::resource::vhost { $::ipaddress:
    listen_port => 80,
    docroot     => '/var/www',
  }
  # Proxy guacamole server
  nginx::resource::location { '/vms':
    proxy            => 'http://localost:8080/guacamole',
    proxy_set_header => [
      'Upgrade $http_upgrade',
      'Connection "Upgrade"'
    ]
    vhost            => $::ipaddress,
  }
  # Allow students to access vms
  nginx::resource::location { '~ /proxy/(?<student_url>.*)':
    proxy => 'http://$student_url;
  }
}
