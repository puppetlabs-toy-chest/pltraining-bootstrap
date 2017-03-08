require 'spec_helper'

describe "bootstrap::profile::learning::local_modules" do
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
    :architecture              => 'x86_64',
  } }

  let(:pre_condition) {
    <<-EOF
      include bootstrap::profile::puppet_forge_server
      include bootstrap::profile::cache_gems
      include localrepo
      include epel
      class { 'bootstrap::profile::ruby':
        install_bundler => true,
      }
    EOF
  }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_wget__fetch(
      "https://forge.puppet.com/v3/files/puppet-staging-2.2.0.tar.gz")
      .with({
        'destination' => '/var/opt/forge/',
      }).that_requires("File[/var/opt/forge/]")
  }

  it {
    is_expected.to contain_wget__fetch(
      "https://forge.puppet.com/v3/files/puppetlabs-stdlib-4.7.0.tar.gz")
      .with({
        'destination' => '/var/opt/forge/',
      }).that_requires("File[/var/opt/forge/]")
  }

  it {
    is_expected.to contain_wget__fetch(
      "https://forge.puppet.com/v3/files/puppetlabs-mysql-3.10.0.tar.gz")
      .with({
        'destination' => '/var/opt/forge/',
      }).that_requires("File[/var/opt/forge/]")
  }

  it {
    is_expected.to contain_wget__fetch(
      "https://forge.puppet.com/v3/files/puppetlabs-ntp-6.0.0.tar.gz")
      .with({
        'destination' => '/var/opt/forge/',
      }).that_requires("File[/var/opt/forge/]")
  }

  it {
    is_expected.to contain_wget__fetch(
      "https://forge.puppet.com/v3/files/dwerder-graphite-5.16.1.tar.gz")
      .with({
        'destination' => '/var/opt/forge/',
      }).that_requires("File[/var/opt/forge/]")
  }

end
