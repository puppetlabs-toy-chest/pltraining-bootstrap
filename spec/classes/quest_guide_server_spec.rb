require 'spec_helper'

describe "bootstrap::profile::learning::quest_guide_server" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
  } }

  let(:pre_condition) {
    <<-EOF
      include bootstrap::profile::learning::quest_guide
      include nginx
    EOF
  }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_file_line("disable_nginx_release")
      .with({
        'path'    => '/etc/yum.repos.d/nginx-release.repo',
        'match'   => 'enabled',
        'line'    => 'enabled=0',
      }).that_requires('Class[nginx]')
  }

  it {
    is_expected.to contain_nginx__resource__server("_")
      .with({
        'ensure'         => 'present',
        'listen_port'    => '80',
        'listen_options' => 'default',
        'www_root'       => '/var/www/quest',
      }).that_requires('File[/var/www/quest]')
  }

  it {
    is_expected.to contain_nginx__resource__location("~ ^/~(.+?)(/.*)?$")
      .with({
        'ensure'         => 'present',
        'server'         => '_',
        'location_alias' => '/home/$1/public_html$2',
        'autoindex'      => 'on',
      })
  }

  it {
    is_expected.to contain_file("/var/www")
      .with({
        'ensure'  => 'directory',
        'owner'   => 'nginx',
        'group'   => 'nginx',
        'mode'    => '755',
      }).that_requires('Package[nginx]')
  }

end
