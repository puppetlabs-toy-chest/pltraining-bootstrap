class bootstrap::profile::learning::graphite_server {

  # Set up an apache server and vhost to serve graphite

  $graph_port = '90'

  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { "*:${graph_port}":
    manage_docroot => false,
    port           => $graph_port,
    servername     => 'learning.puppetlabs.vm',
    docroot        => '/opt/graphite/webapp',
    wsgi_application_group      => '%{GLOBAL}',
    wsgi_daemon_process         => 'graphite',
    wsgi_daemon_process_options => {
      processes          => '5',
      threads            => '5',
      display-name       => '%{GROUP}',
      inactivity-timeout => '120',
    },
    wsgi_import_script          => '/opt/graphite/conf/graphite.wsgi',
    wsgi_import_script_options  => {
      process-group     => 'graphite',
      application-group => '%{GLOBAL}'
    },
    wsgi_process_group          => 'graphite',
    wsgi_script_aliases         => {
      '/' => '/opt/graphite/conf/graphite.wsgi'
    },
    headers => [
      'set Access-Control-Allow-Origin "*"',
      'set Access-Control-Allow-Methods "GET, OPTIONS, POST"',
      'set Access-Control-Allow-Headers "origin, authorization, accept"',
    ],
    directories => [{
      path => '/media/',
      order => 'deny,allow',
      allow => 'from all'}
    ]
  }
}
