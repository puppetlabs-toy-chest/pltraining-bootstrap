#!/bin/bash
HOST_CERT=$(puppet config print hostcert)
PRIV_KEY=$(puppet config print hostprivkey)
CACERT=$(puppet config print cacert)

function puppet_api () {
  local api_endpoint=$1
  local http_method=$2
  local api_data=$3

  curl --cert $HOST_CERT --key $PRIV_KEY --cacert $CACERT \
    https://localhost:4433/$api_endpoint 2>/dev/null \
    -X $http_method \
    --data $api_data \
    -H "Content-Type:application/json"
}

# Get PE Master group id
PE_MASTER_ID=$(puppet_api classifier-api/v1/groups GET | jq -r '.[] | select(.name=="PE Master").id')

# Create deployer user
puppet_api rbac-api/v1/group POST '{"login":"deployer","email":"deployer@puppet.vm","display_name":"Code Deployer","role_ids":[4],"password":"puppetlabs"}'

# Get deployment token
echo "puppetlabs" | puppet access login deployer --lifetime 1y

# Add upstream repo
puppet_api classifier-api/v1/groups/$PE_MASTER_ID POST '{"classes":{"puppet_enterprise::profile::master":{"code_manager_auto_configure":true,"r10k_remote":"https://github.com/puppetlabs-education/classroom-control-pi"}}}' \
  | jq .

# Run puppet to enable code-manager
puppet agent -t

# Install classroom module
puppet module install pltraining-classroom --modulepath=/etc/puppetlabs/code-staging/modules

# Deploy code
puppet code deploy production --wait
