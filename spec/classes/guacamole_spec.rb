require 'spec_helper'

describe "bootstrap::profile::guacamole" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'RedHat',
    :operatingsystemrelease    => '7.3.1611',
    :operatingsystemmajrelease => '7',
    :os_maj_release            => '7',
    :kernelversion             => '3.10.0',
    :offline                   => false,
    :networking                => { 'ip' => '127.0.0.1' },
  } }

  it { is_expected.to compile.with_all_deps }

end
