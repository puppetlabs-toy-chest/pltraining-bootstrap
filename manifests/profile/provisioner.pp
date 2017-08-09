class bootstrap::profile::provisioner (
  $docroot = $bootstrap::params::docroot,
  $psk     = $bootstrap::params::psk,
) inherits bootstrap::params {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  include nginx

  nginx::resource::server { $::fqdn:
    www_root => $docroot,
  }

  file { $docroot:
    ensure => directory,
  }

  file { "${docroot}/bootstrap.sh":
    ensure  => file,
    content => file('bootstrap/provisioning/bootstrap.sh'),
  }

  file { '/etc/puppetlabs/puppet/autosign.rb':
    ensure  => file,
    content => file('bootstrap/provisioning/autosign.rb'),
  }

  file { '/etc/puppetlabs/puppet/psk':
    ensure  => file,
    content => $psk,
  }

  ini_setting { 'autosign':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'autosign',
    value   => '/etc/puppetlabs/puppet/autosign.rb',
    notify  => Service['pe-puppetserver'],
  }

}
