require 'spec_helper'

describe "bootstrap::profile::pdf_stack" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7.2.1511',
    :architecture              => 'x86_64',
  } }

  let(:pre_condition) do
    [ 'include epel',
      'include localrepo',
      'include bootstrap::profile::cache_gems',
      'include bootstrap::profile::ruby',
      'include bootstrap::profile::yum', ]
  end

  it { is_expected.to compile.with_all_deps }

end
