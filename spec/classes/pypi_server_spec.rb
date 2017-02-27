require 'spec_helper'

describe "bootstrap::profile::learning::pypi_server" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_class("supervisord")
      .with({
        'install_pip' => true,
        'setuptools_url' => 'https://bootstrap.pypa.io/ez_setup.py',
      })
  }

  it {
    is_expected.to contain_package("pypiserver")
      .with({
        'ensure' => 'present',
        'provider' => 'pip',
      })
  }

  it {
    is_expected.to contain_file("/opt/pypiserver")
      .with({
        'ensure' => 'directory',
        'mode' => '0640',
      }).that_comes_before('supervisord::program[pypi-server]')
  }

  it {
    is_expected.to contain_file("/opt/pypiserver/packages")
      .with({
        'ensure' => 'directory',
        'mode' => '0640',
      }).that_comes_before('supervisord::program[pypi-server]')
  }

  it {
    is_expected.to contain_supervisord__program("pypi-server")
      .with({
        'command' => 'pypi-server -p 8180 /opt/pypiserver/packages',
        'user' => 'root',
        'autostart' => true,
        'autorestart' => true,
        'priority' => '100',
      })
  }

  it {
    is_expected.to contain_file("/root/.config")
      .with({
        'ensure' => 'directory',
      })
  }

  it {
    is_expected.to contain_file("/root/.config/pip")
      .with({
        'ensure' => 'directory',
      })
  }

  it {
    is_expected.to contain_file("/root/.config/pip/pip.conf")
      .with({
        'ensure'  => 'present',
      }).that_requires('Package[pypiserver]')
  }

end
