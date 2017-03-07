require 'spec_helper'

describe "bootstrap::profile::learning::learning_stickler_gems" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :os                        => {
      :family => 'RedHat',
      :release => {
        :major => '7',
        :minor => '2',
      }
    },
    :path                      => '/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :kernel                    => 'Linux',
    :kernelversion             => '3.10.0',
    :aio_agent_version         => '4.5.3',
    :pe_build                  => '2016.2',
  } }

  let(:pre_condition) {
    <<-EOF
      include bootstrap::profile::stickler_server
    EOF
  }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_bootstrap__profile__stickler_clone_gem('cowsay')
      .with({
      "version" => "0.3.0",
      })
  }

end
