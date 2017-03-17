class bootstrap::profile::learning::quest_guide (
  $git_branch = 'hello_puppet',
  $content_repo_owner = 'kjhenner',
  $content_repo_name  = 'puppet-quest-guide',
) {

  $content_repo_dir   = "/usr/src/${content_repo_name}"

  # Nodejs and npm are required for the GitBook quest guide setup
  class { '::nodejs':
    nodejs_dev_package_ensure => 'present',
    npm_package_ensure        => 'present',
    repo_class                => '::epel',
  }

  # Install gitbook-cli
  package { 'gitbook-cli':
    ensure   => present,
    provider => 'npm',
    require  => Package['npm'],
  }

  # Grab the puppet-quest-guide repository so we can render it
  # as html with gitbook
  vcsrepo { $content_repo_dir:
    ensure   => present,
    provider => git,
    revision => $git_branch,
    source   => "git://github.com/${content_repo_owner}/${content_repo_name}.git",
  }

  # This builds html from the quest guide repository
  exec { 'gitbook build':
    command => '/usr/bin/gitbook install && /usr/bin/gitbook build',
    cwd     => $content_repo_dir,
    creates => "${content_repo_dir}/_book",
    require => [Vcsrepo[$content_repo_dir], Package['gitbook-cli']],
  }

  file { "/var/www/quest":
    ensure  => symlink,
    owner   => 'nginx',
    group   => 'nginx',
    target  => "${content_repo_dir}/_book",
    require => Exec['gitbook build'],
  }

}
