require 'spec_helper'

certname  = `puppet agent --configprint certname`.strip
curlauth  = "--cert /etc/puppetlabs/puppet/ssl/certs/#{certname}.pem "
curlauth += "--key /etc/puppetlabs/puppet/ssl/private_keys/#{certname}.pem "
curlauth += "--cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem"

describe package('pe-puppetserver') do
  it { should be_installed }
end

describe package('pe-console-services') do
  it { should be_installed }
end

describe package('puppet-agent') do
  it { should be_installed }
end

describe port(443) do
  it { should be_listening }
end

describe package('wkhtmltopdf') do
  it { should be_installed }
end

describe command('wkhtmltopdf --version') do
  its(:stdout) { should match /with patched qt/ }
end

describe command('pdftk --version') do
  its(:exit_status) { should eq 0 }
end

describe selinux do
  it { should be_disabled }
end

describe service('firewalld') do
  it { should_not be_enabled }
end

describe command('puppet module list --modulepath /etc/puppetlabs/code/modules') do
  its(:stdout) { should_not match /no modules installed/ }
  its(:exit_status) { should eq 0 }
end

# validate that the yum mirror is complete and consistent
describe command('repoclosure -r local') do
  its(:exit_status) { should eq 0 }
end

# validate that the courseware git repository has been successfully cloned
describe command('git --git-dir=/var/cache/showoff/courseware/.git --work-tree=/var/cache/showoff/courseware status') do
  its(:exit_status) { should eq 0 }
end
describe command('git --git-dir=/var/cache/showoff/courseware/.git --work-tree=/var/cache/showoff/courseware remote -v') do
  its(:stdout) { should match /puppet-training\/courseware.git/ }
end

describe docker_image('centosagent') do
  it { should exist }
end

# validate that puppetdb is running properly
describe command('curl -m 1 http://localhost:8080/pdb/meta/v1/version') do
  its(:stdout) { should match /version/ }
end

# check the status api
describe command("curl https://#{certname}:4433/status/v1/simple #{curlauth}") do
  its(:stdout) { should match /running/ }
end
