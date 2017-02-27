require 'spec_helper'

describe "bootstrap::profile::learning::graphite_reqs" do
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
      include wget
      include bootstrap::profile::learning::install
      include epel
    EOF
  }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/D/Django/Django-1.5.tar.gz")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/c/carbon/carbon-0.9.15.tar.gz")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/T/Twisted/Twisted-11.1.0.tar.bz2")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/t/txAMQP/txAMQP-0.4.tar.gz")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/g/graphite-web/graphite-web-0.9.15.tar.gz")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/d/django-tagging/django-tagging-0.3.1.tar.gz")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_bootstrap__profile__learning__pypi_cached_pkg(
      "https://pypi.python.org/packages/source/w/whisper/whisper-0.9.15.tar.gz")
      .with({
        'pypi_pkg_dir' => '/opt/pypiserver/packages',
      }).that_requires("Class[bootstrap::profile::learning::pypi_server]")
  }

  it {
    is_expected.to contain_package("libffi-devel")
      .with({
        'ensure' => 'present',
      })
  }

  it {
    is_expected.to contain_package("openssl-devel")
      .with({
        'ensure' => 'present',
      })
  }

  it {
    is_expected.to contain_package("python-devel")
      .with({
        'ensure' => 'present',
      })
  }

  it {
    is_expected.to contain_exec("install requests[security]")
      .with({
        "command" => "/bin/pip install requests[security] --index \"https://pypi.python.org/simple/\"",
      }).that_requires("Package[libffi-devel]")
  }

  it {
    is_expected.to contain_exec("install requests[security]")
      .with({
        "command" => "/bin/pip install requests[security] --index \"https://pypi.python.org/simple/\"",
      }).that_requires("Package[openssl-devel]")
  }

  it {
    is_expected.to contain_exec("install requests[security]")
      .with({
        "command" => "/bin/pip install requests[security] --index \"https://pypi.python.org/simple/\"",
      }).that_requires("Package[python-devel]")
  }

  it {
    is_expected.to contain_package("python-sqlite3dbm")
      .with({
        'ensure' => '0.1.4-6.el7',
        'require' => 'Exec[install requests[security]]',
      })
  }

end
