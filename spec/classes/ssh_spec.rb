require 'spec_helper'

describe "bootstrap::profile::learning::ssh" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :architecture              => 'x86_64',
  } }

  let(:pre_condition) {
    <<-EOF
      include epel
      include localrepo
      include bootstrap::profile::ruby
      include bootstrap::profile::cache_gems
    EOF
  }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_augeas("GSSAPI_enable")
      .with({
        'context' => '/files/etc/ssh/sshd_config',
        'changes' => 'set GSSAPIAuthentication yes',
        'require' => 'Package[ruby_augeas_lib]',
      })
  }

  it {
    is_expected.to contain_augeas("disable_key_checking")
      .with({
        'context' => '/files/etc/ssh/ssh_config',
        'changes' => [
          "set Host[.='*.puppet.vm'] *.puppet.vm",
          "set Host[.='*.puppet.vm']/StrictHostKeyChecking no",
          "set Host[.='*.puppet.vm']/UserKnownHostsFile /dev/null"
        ],
        'require' => 'Package[ruby_augeas_lib]',
      })
  }

  it {
    is_expected.to contain_service("sshd")
      .with({
        'ensure'     => 'running',
        'enable'     => true,
        'hasstatus'  => true,
        'hasrestart' => true,
      })
  }

end
