require 'spec_helper'

describe "bootstrap::profile::learning::multi_node" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_file("/etc/puppetlabs/code/modules")
      .with({
        'ensure' => 'directory',
      }).that_comes_before('File[/etc/puppetlabs/code/modules/multi_node]')
  }

  it {
    is_expected.to contain_file("/etc/puppetlabs/code/modules/multi_node")
      .with({
        'ensure'  => 'directory',
        'recurse' => true,
        'source'  => 'puppet:///modules/bootstrap/learning/multi_node',
      })
  }

end
