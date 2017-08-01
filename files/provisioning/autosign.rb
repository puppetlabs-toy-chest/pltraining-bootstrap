#! /opt/puppetlabs/puppet/bin/ruby
require 'puppet/ssl'

csr = Puppet::SSL::CertificateRequest.from_s(STDIN.read)
psk = File.read('/etc/puppetlabs/puppet/psk').strip

pass = csr.custom_attributes.find do |a|
  ['challengePassword', '1.2.840.113549.1.9.7'].include? a['oid']
end

if pass['value'] == psk
    exit 0
else
    puts "Preshared key does not match!"
    puts " - PSK: ${psk}"
    puts " - PASS: ${pass['value']}"
    exit 1
end
