require 'spec_helper'

describe "bootstrap::profile::learning::install" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :path                      => '/tmp',
    :pe_compile_master         => 'false',
    :pe_build                  => '2016.2',
    :aio_agent_version         => '4.5.2',
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

  let(:pre_condition) {
    <<-EOF
      include epel
    EOF
  }

  it { is_expected.to compile }

  it {
    is_expected.to contain_package("python-pip")
      .with({
        'ensure' => 'present',
      }).that_requires("Class[epel]")
  }

  it {
    is_expected.to contain_file("/usr/bin/pip-python")
      .with({
        'ensure' => 'symlink',
        'target' => '/usr/bin/pip',
      }).that_requires("Package[python-pip]")
  }

  it {
    is_expected.to contain_service("pe-puppet")
      .with({
        'ensure' => 'stopped',
        'enable' => 'false',
      })
  }

  it {
    is_expected.to contain_service("puppet")
      .with({
        'ensure' => 'stopped',
        'enable' => 'false',
      })
  }

  it {
    is_expected.to contain_package("graphviz")
      .with({
        'ensure' => 'present',
      })
  }

  it {
    is_expected.to contain_file("/etc/motd")
      .with({
        'ensure' => 'file',
        'owner' => 'root',
        'mode' => '0644',
        'source' => 'puppet:///modules/bootstrap/learning/README',
      })
  }

  it {
    is_expected.to contain_file("/root/README")
      .with({
        'ensure' => 'file',
        'owner' => 'root',
        'mode' => '0644',
        'source' => 'puppet:///modules/bootstrap/learning/README',
      })
  }

  it {
    is_expected.to contain_file("/var/lib/hiera")
      .with({
        'ensure' => 'directory',
      })
  }

  it {
    is_expected.to contain_file("/usr/local/bin/reset_demo")
      .with({
        'ensure' => 'file',
        'owner' => 'root',
        'mode' => '0500',
        'source' => 'puppet:///modules/bootstrap/learning/reset_demo',
      })
  }

  it {
    is_expected.to contain_file_line("sshd_config")
      .with({
        'ensure' => 'present',
        'path' => '/etc/ssh/sshd_config',
        'line' => 'GSSAPIAuthentication yes',
        'match' => '^GSSAPIAuthentication',
      })
  }

end
