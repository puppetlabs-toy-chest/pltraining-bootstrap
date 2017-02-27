require 'spec_helper'

describe "bootstrap::profile::learning::graphite_server" do
  let(:node) { 'test.example.com' }

  let(:facts) { {
    :os                        => {
      :family => 'RedHat',
      :release => {
        :major => '7',
        :minor => '2',
      }
    },
    :path                      => '/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2.1511',
    :operatingsystemmajrelease => '7',
    :kernel                    => 'Linux',
    :kernelversion             => '3.10.0',
    :aio_agent_version         => '4.5.3',
    :pe_build                  => '2016.2',
  } }

  let(:pre_condition) {
    <<-EOF
      include wget
      include bootstrap::profile::learning::install
      include epel
    EOF
  }

  it { is_expected.to compile.with_all_deps }

  it {
    is_expected.to contain_apache__vhost("*:90")
      .with({
        'manage_docroot' => false,
        'port' => '90',
        'servername' => 'learning.puppetlabs.vm',
        'docroot' => '/opt/graphite/webapp',
        'wsgi_application_group' => '%{GLOBAL}',
        'wsgi_daemon_process' => 'graphite',
        'wsgi_daemon_process_options' => {
          'processes'          => '5',
          'threads'            => '5',
          'display-name'       => '%{GROUP}',
          'inactivity-timeout' => '120',
        },
        'wsgi_import_script' => '/opt/graphite/conf/graphite.wsgi',
        'wsgi_import_script_options' => {
          'process-group'     => 'graphite',
          'application-group' => '%{GLOBAL}',
        },
        'wsgi_process_group' => 'graphite',
        'wsgi_script_aliases' => {
          '/' => '/opt/graphite/conf/graphite.wsgi',
        },
        'headers' => ["set Access-Control-Allow-Origin \"*\"", "set Access-Control-Allow-Methods \"GET, OPTIONS, POST\"", "set Access-Control-Allow-Headers \"origin, authorization, accept\""],
        'directories' => [{
          'path'  => '/media/',
          'order' => 'deny,allow',
          'allow' => 'from all',
        }],
      })
  }

end
