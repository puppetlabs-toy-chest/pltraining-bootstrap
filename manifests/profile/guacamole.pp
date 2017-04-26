class bootstrap::profile::guacamole {

  # Contain this class because the containing class has an ordering
  # dependency applied to it
  contain docker

  # The CIAB will always have a known address (10.0.0.1) based on the
  # access point
  $ciab_ip = $::networking.dig('interfaces', 'ap0', 'bindings', 0, 'address')

  if $ciab_ip {
    docker::run {'ciab-guacd':
      image => 'glyptodon/guacd',
      extra_parameters => [
        "--add-host ${::fqdn}:${ciab_ip}",
      ],
    }

    if defined('$::guacamole_ports') {
      docker::run {'ciab-guacamole':
	image            => 'glyptodon/guacamole',
	links            => ['ciab-guacd:guacd'],
	ports            => ['8080:8080'],
	env              => [
	  "MYSQL_HOSTNAME=${::fqdn}",
	  'MYSQL_DATABASE=guacamole_db',
	  'MYSQL_USER=guacamole_user',
	  'MYSQL_PASSWORD=some_password',
	],
	extra_parameters => [
	  "--add-host ${::fqdn}:${ciab_ip}",
	],
	require => [Mysql::Db['guacamole_db'],Docker::Run['ciab-guacd']],
      }

      file { '/usr/src/guacamole':
	ensure => directory,
      }

      $guacamole_initdb_file = '/usr/src/guacamole/initdb.sql'

      concat { $guacamole_initdb_file:
	ensure  => present,
      }

      # Start with the dynamic template that generates the Guacamole 0.9.10
      # database schema, then concat database upgrade scripts as additional
      # fragments as new versions of the application are released with
      # database schema changes.
      concat::fragment { 'guacamole 0.9.10 init script':
	target  => $guacamole_initdb_file,
	content => epp('bootstrap/classroom_in_a_box/guacamole_db.sql.epp'),
	order   => '10',
      }

      concat::fragment { 'guacamole 0.9.11 upgrade script':
	target => $guacamole_initdb_file,
	source => 'puppet:///modules/bootstrap/classroom_in_a_box/upgrade-pre-0.9.11.sql',
	order  => '20',
      }

      $override_options = {
	'mysqld' => {
	  'bind-address' => '0.0.0.0',
	}
      }

      class {'::mysql::server':
	override_options => $override_options,
      }
      contain ::mysql::server

      mysql::db {'guacamole_db':
	user     => 'guacamole_user',
	password => 'some_password',
	host     => '%',
	grant    => ['SELECT','INSERT','UPDATE','DELETE'],
	sql      => $guacamole_initdb_file,
	require  => File[$guacamole_initdb_file],
      }

      firewall { '010 allow mysql':
	proto  => 'tcp',
	action => 'accept',
	dport   => '3306',
      }
    }
  }
    
}
