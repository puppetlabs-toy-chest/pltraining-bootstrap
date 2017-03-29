require 'spec_helper'

describe 'bootstrap::profile::vagrant' do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :architecture              => 'x86_64',
    :puppetversion             => '4.9.4',
    :kernel                    => 'Linux',
    :offline                   => 'false',
    :num_win_vms               => '0',
  } }

  it { is_expected.to contain_file("/etc/puppetlabs/facter")
    .with({
      'ensure' => 'directory',
      'owner'  => 'root',
      'group'  => 'root',
    })
  }

  it { is_expected.to contain_file("/etc/puppetlabs/facter/facts.d")
    .with({
      'ensure' => 'directory',
      'owner'  => 'root',
      'group'  => 'training',
      'mode'   => '0775',
    })
  }

  it { is_expected.to contain_class("vagrant")
    .with({
      'version' => '1.8.7',
    })
  }

  it { is_expected.to compile.with_all_deps }

end
