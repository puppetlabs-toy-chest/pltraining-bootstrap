require 'spec_helper'

describe "bootstrap::profile::classroom_ssh" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :architecture              => 'x86_64',
  } }

  let(:pre_condition) do
    [ 'include epel',
      'include localrepo',
      'include bootstrap::profile::cache_gems',
      'include bootstrap::profile::ruby' ]
  end

  it { is_expected.to compile.with_all_deps }

end
