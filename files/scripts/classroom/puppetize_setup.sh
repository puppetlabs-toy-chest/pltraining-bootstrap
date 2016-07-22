#!/bin/bash
# This is a basic setup script that creates the user and token, 
# sets up code manager and points it at the upstream repo, 
# installs the classroom module and deploys the code.
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
echo Creating deployer user with password "puppetlabs"
puppet_api rbac-api/v1/group POST '{"login":"deployer","email":"deployer@puppet.vm","display_name":"Code Deployer","role_ids":[4],"password":"puppetlabs"}'

# Get deployment token
echo Requesting token for "deployer"
echo "puppetlabs" | puppet access login deployer --lifetime 1y

# Add upstream repo
echo Configuring Code manager
puppet_api classifier-api/v1/groups/$PE_MASTER_ID POST '{"classes":{"puppet_enterprise::profile::master":{"code_manager_auto_configure":true,"r10k_remote":"https://github.com/puppetlabs-education/classroom-control-pi"}}}' \
  | jq .

# Run puppet to enable code-manager
echo Running puppet for initial Code Manager configuration
puppet agent -t

# Install classroom module
echo Installng the classroom module to the global modulepath
puppet module install pltraining-classroom --modulepath=/etc/puppetlabs/code-staging/modules

# Deploy code
echo Deploying production environment and global modules
puppet code deploy production --wait | jq .
