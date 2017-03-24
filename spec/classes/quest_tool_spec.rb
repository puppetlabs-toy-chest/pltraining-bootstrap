require 'spec_helper'

describe "bootstrap::profile::learning::quest_tool" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_package("tmux")
      .with({
        'ensure' => 'present',
      })
  }

  it {
    is_expected.to contain_file("/root/.tmux.conf")
      .with({
        'ensure' => 'file',
        'source' => 'puppet:///modules/bootstrap/learning/tmux.conf',
      })
  }

  it {
    is_expected.to contain_file("/root/.bashrc.learningvm")
      .with({
        'ensure' => 'file',
        'source' => 'puppet:///modules/bootstrap/learning/bashrc.learningvm',
      })
  }

  it {
    is_expected.to contain_package("quest")
      .with({
        'provider' => 'gem',
      })
  }

  it {
    is_expected.to contain_file("/etc/systemd/system/quest.service")
      .with({
        'ensure' => 'file',
        'mode' => '0644',
      })
  }

  it { is_expected.to contain_file("/etc/systemd/system/quest.service")
    .with_content(/^\s*Description=Run the quest tool service$/)
  }

  it {
    is_expected.to contain_service("quest")
      .with({
        'provider' => 'systemd',
        'ensure' => 'running',
        'enable' => true,
      }).that_requires("Package[quest]")
  }

  it {
    is_expected.to contain_service("quest")
      .with({
        'provider' => 'systemd',
        'ensure' => 'running',
        'enable' => true,
      }).that_requires("File[/etc/systemd/system/quest.service]")
  }

end
