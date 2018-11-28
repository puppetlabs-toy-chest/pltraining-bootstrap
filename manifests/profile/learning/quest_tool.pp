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

  # The quest gem specifies "~> 4.1" for the timers gem, but versions
  # of that gem >= 4.2 require an upgraded version of ruby. The best option
  # would be to update the quest gem's gemspec file to specify "~> 4.1.0",
  # but it's currently unknown how to publish an update to the quest gem.
  # So preinstall the timers gem with a pinned version here to avoid the
  # upgraded ruby version requirement.
  package { 'timers':
    ensure   => '4.1.2',
    provider => 'gem',
  }

  package { 'quest':
    provider => gem,
    require  => Package['timers'],
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
