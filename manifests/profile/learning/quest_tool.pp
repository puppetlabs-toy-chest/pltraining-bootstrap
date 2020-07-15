class bootstrap::profile::learning::quest_tool (
  $content_repo_dir = '/usr/src/puppet-quest-guide'
) {

  $home = '/root'

  package { 'tmux':
    ensure  => 'present',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0744',
  }

  file { "${home}/.tmux.conf":
    ensure => file,
    source => 'puppet:///modules/bootstrap/learning/tmux.conf',
  }

  file { "${home}/.bashrc.learningvm":
    ensure => file,
    source => 'puppet:///modules/bootstrap/learning/bashrc.learningvm',
  }

  # Install a specific version of minitest before the quest gem. This version
  # does not force a specific version of Ruby as a dependency so it will not
  # break the build if a later version is installed.
  package { 'minitest':
    ensure   => '5.11.1',
    provider => gem,
    before   => Package['quest'],
  }

  package { 'quest':
    provider => gem,
  }

  file { '/etc/systemd/system/quest.service':
    ensure  => file,
    content => epp('bootstrap/learning/quest.service.epp', {'test_dir' => "${content_repo_dir}/tests"}),
    mode    => '0644',
  }

  service { 'quest':
    provider => systemd,
    ensure   => 'running',
    enable   => true,
    require  => [Package['quest'], File['/etc/systemd/system/quest.service']],
  }

} 
