class bootstrap::profile::learning::quest_guide_server {
  
  $proxy_port = '80'
  $graph_port = '90'

  include nginx

  file_line { 'disable_nginx_release':
    path    => '/etc/yum.repos.d/nginx-release.repo',
    match   => 'enabled',
    line    => 'enabled=0',
    require => Class['nginx'],
  }

  nginx::resource::server { "_":
    ensure         => present,
    listen_port    => "${proxy_port}",
    listen_options => 'default',
    www_root       => "/var/www/quest",
    require        => File["/var/www/quest"],
  }

  # Set up ~ home pages for the defined resource types quest 

  nginx::resource::location { '~ ^/~(.+?)(/.*)?$':
    ensure         => present,
    server         => '_',
    location_alias => '/home/$1/public_html$2',
    autoindex      => 'on',
  }

  file { ["/var/www"]:
    ensure => directory,
    owner  => 'nginx',
    group  => 'nginx',
    mode   => '755',
    require => Package['nginx'], 
  }

}
