class bootstrap::profile::puppet_forge_server(
  $module_source_dir = '/var/opt/forge/',
  $port              = '8085'
){
  user { 'puppet-forge-server':
    ensure     => present,
    gid        => 'puppet-forge-server',
    managehome => true,
  }
  group { 'puppet-forge-server':
    ensure => present,
  }
  vcsrepo { '/usr/src/puppet-forge-server':
    ensure   => present,
    provider => git,
    owner    => 'puppet-forge-server',
    group    => 'puppet-forge-server',
    source   => 'https://github.com/unibet/puppet-forge-server.git',
    revision => '1.10.1',
    require  => User['puppet-forge-server'],
  }
  exec { '/usr/local/bin/bundle install':
    cwd         => '/usr/src/puppet-forge-server',
    unless      => '/usr/local/bin/bundle check',
    user        => 'puppet-forge-server',
    environment => ['HOME=/home/puppet-forge-server'],
    logoutput   => on_failure,
    require     => [Vcsrepo['/usr/src/puppet-forge-server'], Package['bundler'], User['puppet-forge-server']],
  }
  file { $module_source_dir:
    ensure => directory,
    before => Service['forge'],
  }
  $forge_config_hash = {
    'module_source_dir' => $module_source_dir,
    'port'              => $port,
  }
  file { '/etc/systemd/system/forge.service':
    content => epp('bootstrap/forge.service.epp', $forge_config_hash),
    notify  => Service['forge'],
  }
  service { 'forge':
    ensure  => running,
    enable  => true,
    require => Exec['/usr/local/bin/bundle install']
  }
  ini_setting { 'module_repository':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'main',
    setting => 'module_repository',
    value   => "http://localhost:${port}"
  }
}
