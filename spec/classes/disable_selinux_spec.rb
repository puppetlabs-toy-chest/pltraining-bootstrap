require 'spec_helper'

describe "bootstrap::profile::disable_selinux" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'RedHat',
    :operatingsystemmajrelease => '7',
    :os_maj_release            => '7',
  } }

  it { is_expected.to compile.with_all_deps }

end
