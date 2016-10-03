require 'spec_helper'

describe "bootstrap::profile::cache_docker" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                   => 'RedHat',
    :operatingsystem            => 'CentOS',
    :operatingsystemrelease     => '7.2.1511',
    :operatingsystemmajrelease  => '7',
    :kernelversion              => '3.10.0',
  } }

  it { is_expected.to compile.with_all_deps }

end
