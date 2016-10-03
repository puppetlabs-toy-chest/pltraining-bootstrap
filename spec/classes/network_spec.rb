require 'spec_helper'

describe "bootstrap::profile::network" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :os                     => { :release => { :major => '7' } },
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '7.2.1511',
  } }

  it { is_expected.to compile.with_all_deps }

end
