require 'spec_helper'

describe "bootstrap::profile::puppet_forge_server" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

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

  it {
    is_expected.to contain_package("puppet-forge-server")
      .with({
        'ensure'   => 'present',
        'provider' => 'gem',
      }).that_comes_before('service[forge]')
  }

  it {
    is_expected.to contain_package("multi_json")
      .with({
      'ensure'   => '1.7.8',
        'provider' => 'gem',
      }).that_comes_before('service[forge]')
  }

end
