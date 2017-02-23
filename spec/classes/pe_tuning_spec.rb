require 'spec_helper'

describe "bootstrap::profile::learning::pe_tuning" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_exec("mkdir -p /etc/puppetlabs/code")
      .with({
        'path' => '/bin',
      }).that_comes_before("File[/etc/puppetlabs/puppet/hiera.yaml]")
  }

  it {
    is_expected.to contain_exec("mkdir -p /etc/puppetlabs/code")
      .with({
        'path' => '/bin',
      }).that_comes_before("File[/etc/puppetlabs/code/hieradata]")
  }

  it {
    is_expected.to contain_file("/etc/puppetlabs/puppet/hiera.yaml")
      .with({
        'ensure' => 'file',
        'source' => 'puppet:///modules/bootstrap/learning/hiera.yaml',
      })
  }

  it {
    is_expected.to contain_file("/etc/puppetlabs/code/hieradata")
      .with({
        'ensure' => 'directory',
      })
  }

  it {
    is_expected.to contain_file("/etc/puppetlabs/code/hieradata/defaults.yaml")
      .with({
        'ensure' => 'file',
        'source' => 'puppet:///modules/bootstrap/learning/defaults.yaml',
      }).that_requires('File[/etc/puppetlabs/code/hieradata]')
  }

end
