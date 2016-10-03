require 'spec_helper'

describe "bootstrap::profile::get_pe" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :architecture              => 'x86_64',
    :staging_http_get          => 'curl',
    :path                      => '/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin'
  } }

  let(:pre_condition) do
    [ 'include bootstrap::profile::installer_staging' ]
  end

  it { is_expected.to compile.with_all_deps }

end
