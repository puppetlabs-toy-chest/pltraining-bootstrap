require 'spec_helper'

describe "bootstrap::profile::get_agent_packages" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :staging_http_get          => 'curl',
  } }

  it { is_expected.to compile.with_all_deps }

end
