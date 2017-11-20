class bootstrap::profile::courseware ($key) {
  include bootstrap::params

  file { 'courseware ssh key':
    path    => "/home/${bootstrap::params::admin_user}/.ssh/id_rsa",
    owner   => $bootstrap::params::admin_user,
    group   => $bootstrap::params::admin_user,
    mode    => '0600',
    content => $key, # to come from hiera auto param lookup
  }

  dirtree { $bootstrap::params::courseware_cache:
    ensure  => present,
    parents => true,
  }

  file { $bootstrap::params::courseware_cache:
    ensure  => directory,
    owner   => $bootstrap::params::admin_user,
    group   => $bootstrap::params::admin_user,
  }

  sshkey { 'github.com':
    ensure => 'present',
    key    => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
    type   => 'ssh-rsa',
  }

  vcsrepo { $bootstrap::params::courseware_cache:
    ensure   => latest,
    provider => git,
    source   => $bootstrap::params::courseware_url,
    revision => 'master',
    user     => $bootstrap::params::admin_user,
    require  => [ File['courseware ssh key'], Sshkey['github.com'] ],
  }

}
