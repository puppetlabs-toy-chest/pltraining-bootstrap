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
