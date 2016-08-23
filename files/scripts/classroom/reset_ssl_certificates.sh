#! /bin/sh
#
# Automate the process of regenerating certificates on a monolithic master
# https://docs.puppet.com/pe/latest/trouble_regenerate_certs_monolithic.html
#
if [[ $(hostname) != "master.puppetlabs.vm" && $(hostname) != "classroom.puppetlabs.vm" ]]
then
  echo "This tool is intended to be run on the classroom master."
  echo "Do you wish to continue anyway? [yes/NO]"
  read junk
  [ "${junk}" != "yes" ] && exit 1
fi

echo
echo
echo "################################################################################"
echo
echo "This script will completely reset all certificates on a standalone Puppet Master"
echo
echo "             Press Control-C now to abort or [enter] to continue."
echo
echo "################################################################################"
echo
read junk

TIMESTAMP=$(date '+%s')
CERTNAME=$(puppet master --configprint certname)

mkdir -p ~/certificates.bak/{puppet,puppetdb,puppet-dashboard,console-services,postgresql}
cp -a /etc/puppetlabs/puppet/ssl ~/certificates.bak/puppet/${TIMESTAMP}
cp -a /etc/puppetlabs/puppetdb/ssl ~/certificates.bak/puppetdb/${TIMESTAMP}
cp -a /opt/puppetlabs/server/data/console-services/certs/ ~/certificates.bak/console-services/${TIMESTAMP}
cp -a /opt/puppetlabs/server/data/postgresql/9.4/data/certs/ ~/certificates.bak/postgresql/${TIMESTAMP}

echo "Certificates backed up to ~/certificates.bak"

puppet resource service puppet ensure=stopped
puppet resource service pe-puppetserver ensure=stopped
puppet resource service pe-activemq ensure=stopped
puppet resource service mcollective ensure=stopped
puppet resource service pe-puppetdb ensure=stopped
puppet resource service pe-postgresql ensure=stopped
puppet resource service pe-console-services ensure=stopped
puppet resource service pe-nginx ensure=stopped
puppet resource service pe-orchestration-services ensure=stopped
puppet resource service pxp-agent ensure=stopped

rm -rf /etc/puppetlabs/puppet/ssl/*
rm -f /opt/puppetlabs/puppet/cache/client_data/catalog/${CERTNAME}.json

puppet cert list -a
puppet cert --generate ${CERTNAME} --dns_alt_names "$(puppet master --configprint dns_alt_names)" --verbose
puppet cert generate pe-internal-classifier
puppet cert generate pe-internal-dashboard
puppet cert generate pe-internal-mcollective-servers
puppet cert generate pe-internal-peadmin-mcollective-client
puppet cert generate pe-internal-puppet-console-mcollective-client
puppet cert generate pe-internal-orchestrator
cp /etc/puppetlabs/puppet/ssl/ca/ca_crl.pem /etc/puppetlabs/puppet/ssl/crl.pem
chown -R pe-puppet:pe-puppet /etc/puppetlabs/puppet/ssl
echo "Puppet Master certificates regenerated"

rm -rf /etc/puppetlabs/puppetdb/ssl/*
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /etc/puppetlabs/puppetdb/ssl/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /etc/puppetlabs/puppetdb/ssl/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /etc/puppetlabs/puppetdb/ssl/${CERTNAME}.private_key.pem
chown -R pe-puppetdb:pe-puppetdb /etc/puppetlabs/puppetdb/ssl
echo "PuppetDB certificates regenerated"

rm -rf /opt/puppetlabs/server/data/postgresql/9.4/data/certs/*
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /opt/puppetlabs/server/data/postgresql/9.4/data/certs/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /opt/puppetlabs/server/data/postgresql/9.4/data/certs/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /opt/puppetlabs/server/data/postgresql/9.4/data/certs/${CERTNAME}.private_key.pem
chmod 400 /opt/puppetlabs/server/data/postgresql/9.4/data/certs/*
chown pe-postgres:pe-postgres /opt/puppetlabs/server/data/postgresql/9.4/data/certs/*
echo "PostgreSQL certificates regenerated"

rm -rf /opt/puppetlabs/server/data/console-services/certs/*
cp /etc/puppetlabs/puppet/ssl/certs/pe-internal-classifier.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-classifier.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-classifier.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-classifier.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-classifier.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-classifier.private_key.pem
cp /etc/puppetlabs/puppet/ssl/certs/${CERTNAME}.pem /opt/puppetlabs/server/data/console-services/certs/${CERTNAME}.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/${CERTNAME}.pem /opt/puppetlabs/server/data/console-services/certs/${CERTNAME}.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/${CERTNAME}.pem /opt/puppetlabs/server/data/console-services/certs/${CERTNAME}.private_key.pem
cp /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.private_key.pem
chown -R pe-console-services:pe-console-services /opt/puppetlabs/server/data/console-services/certs
echo "Puppet Enterprise Console Services certificates regenerated"

cp /etc/puppetlabs/puppet/ssl/certs/pe-internal-dashboard.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.cert.pem
cp /etc/puppetlabs/puppet/ssl/public_keys/pe-internal-dashboard.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.public_key.pem
cp /etc/puppetlabs/puppet/ssl/private_keys/pe-internal-dashboard.pem /opt/puppetlabs/server/data/console-services/certs/pe-internal-dashboard.private_key.pem
echo "Puppet Enterprise Console certificates regenerated"

puppet resource service pe-puppetserver ensure=running
puppet resource service pe-postgresql ensure=running
puppet resource service pe-puppetdb ensure=running
puppet resource service pe-console-services ensure=running
puppet resource service pe-nginx ensure=running
puppet resource service pe-activemq ensure=running
puppet resource service mcollective ensure=running
puppet resource service puppet ensure=running
puppet resource service pe-orchestration-services ensure=running
puppet resource service pxp-agent ensure=running

puppet agent -t
puppet resource service puppet ensure=running

echo "All certificates regenerated. Please regenerate certificates on all agents now."
