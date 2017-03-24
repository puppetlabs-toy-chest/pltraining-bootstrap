require 'spec_helper'

describe "bootstrap::profile::learning::quest_guide" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_class("nodejs")
      .with({
        'nodejs_dev_package_ensure' => 'present',
        'npm_package_ensure'        => 'present',
        'repo_class'                => '::epel',
      })
  }

  it {
    is_expected.to contain_package("gitbook-cli")
      .with({
        'ensure'   => 'present',
        'provider' => 'npm',
      }).that_requires('Package[npm]')
  }

  it {
    is_expected.to contain_vcsrepo("/usr/src/puppet-quest-guide")
      .with({
        'ensure'   => 'present',
        'provider' => 'git',
        'revision' => 'master',
        'source'   => 'git://github.com/puppetlabs/puppet-quest-guide.git',
      })
  }

  it {
    is_expected.to contain_exec("gitbook build")
      .with({
        'command' => '/usr/bin/gitbook install && /usr/bin/gitbook build',
        'cwd'     => '/usr/src/puppet-quest-guide',
        'creates' => '/usr/src/puppet-quest-guide/_book',
      }).that_requires("Vcsrepo[/usr/src/puppet-quest-guide]")
  }

  it {
    is_expected.to contain_exec("gitbook build")
      .with({
        'command' => '/usr/bin/gitbook install && /usr/bin/gitbook build',
        'cwd'     => '/usr/src/puppet-quest-guide',
        'creates' => '/usr/src/puppet-quest-guide/_book',
      }).that_requires("Package[gitbook-cli]")
  }

  it {
    is_expected.to contain_file("/var/www/quest")
      .with({
        'ensure'  => 'symlink',
        'owner'   => 'nginx',
        'group'   => 'nginx',
        'target'  => '/usr/src/puppet-quest-guide/_book',
      }).that_requires('Exec[gitbook build]')
  }

end
