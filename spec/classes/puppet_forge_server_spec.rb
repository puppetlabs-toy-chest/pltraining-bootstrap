require 'spec_helper'

describe "bootstrap::profile::puppet_forge_server" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :architecture              => 'x86_64',
  } }

  it { is_expected.to compile.with_all_deps }

  let(:pre_condition) {
    <<-EOF
      include localrepo
      include epel
      include bootstrap::profile::cache_gems
      class { 'bootstrap::profile::ruby':
        install_bundler => true,
      }
    EOF
  }

  it {
    is_expected.to contain_user('puppet-forge-server')
      .with({
        'ensure'     => 'present',
        'gid'        => 'puppet-forge-server',
        'managehome' => 'true',
      })
  }

  it {
    is_expected.to contain_group('puppet-forge-server')
      .with({
        'ensure'     => 'present',
      })
  }

  it {
    is_expected.to contain_vcsrepo('/usr/src/puppet-forge-server')
      .with({
        'ensure'     => 'present',
        'provider'   => 'git',
        'owner'      => 'puppet-forge-server',
        'group'      => 'puppet-forge-server',
        'source'     => 'https://github.com/unibet/puppet-forge-server.git',
        'revision'   => '1.9.0',
      }).that_requires('user[puppet-forge-server]')
  }

  it {
    is_expected.to contain_exec('/usr/local/bin/bundle install')
      .with({
        'cwd'         => '/usr/src/puppet-forge-server',
        'unless'      => '/usr/local/bin/bundle check',
        'user'        => 'puppet-forge-server',
        'environment' => "[\"HOME=/home/puppet-forge-server\"]",
        'logoutput'   => 'on_failure',
      })
  }

  it {
    is_expected.to contain_file("/var/opt/forge/")
      .with({
        'ensure' => 'directory',
      }).that_comes_before('service[forge]')
  }

  it {
    is_expected.to contain_file("/etc/systemd/system/forge.service")
  }

  it {
    is_expected.to contain_service("forge")
      .with({
        'ensure' => 'running',
        'enable' => 'true',
      })
  }

end
