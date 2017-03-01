class bootstrap::profile::puppet_forge_server(
  $module_source_dir = '/var/opt/forge',
  $port              = '8085'
){
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
    ensure => running,
    enable => true,
  }
  package { 'puppet-forge-server':
    ensure   => present,
    provider => 'gem',
    before   => Service['forge'],
  }
  package { 'multi_json':
    ensure   => '1.7.8',
    provider => 'gem',
    before   => Service['forge'],
  }
}
