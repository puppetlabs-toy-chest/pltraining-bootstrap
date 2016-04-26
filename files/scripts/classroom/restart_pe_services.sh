#! /bin/bash
set -e
echo "Restarting PE stack services. This may take a few minutes"

echo "Restarting pe-postgresql.service..."
systemctl restart pe-postgresql.service

echo "Restarting pe-puppetdb.service..."
systemctl restart pe-puppetdb.service

echo "Restarting pe-puppetserver.service..."
systemctl restart pe-puppetserver.service

echo "Restarting pe-console-services.service..."
systemctl restart pe-console-services.service

echo "Restarting pe-orchestration-services.service..."
systemctl restart pe-orchestration-services.service
