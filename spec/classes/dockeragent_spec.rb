require 'spec_helper'

describe "bootstrap::profile::dockeragent" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :os                        => {
      :family => 'RedHat',
      :release => {
        :major => '7',
        :minor => '2',
      }
    },
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :kernel                    => 'Linux',
    :kernelversion             => '3.10.0',
  } }

  it { is_expected.to compile.with_all_deps }

  it { is_expected.to contain_class("dockeragent")
    .with({
      'create_no_agent_image' => true,
      'lvm_bashrc'            => true,
    })
  }

end
