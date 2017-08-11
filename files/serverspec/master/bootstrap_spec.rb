require 'spec_helper'

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

describe command('git --git-dir=/var/cache/showoff/courseware/.git --work-tree=/var/cache/showoff/courseware status') do
  its(:exit_status) { should eq 0 }
end

describe command('docker images') do
  its(:stdout) { should match /centosagent/ }
end

describe docker_image('centosagent') do
  it { should exist }
end
