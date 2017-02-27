require 'spec_helper'

describe 'bootstrap::profile::abalone' do
  let(:node) { 'test.example.com' }

  it { is_expected.to contain_class("abalone")
    .with({
      'port'       => '9091',
      'bannerfile' => '/etc/issue',
    })
  }

  it { is_expected.to contain_file_line("pam_securetty")
    .with({
      'path'  => '/etc/pam.d/login',
      'line'  => '#auth [user_unknown=ignore success=ok ignore default=bad] pam_security.so',
      'match' => 'pam_securetty.so$',
    })
  }

end
