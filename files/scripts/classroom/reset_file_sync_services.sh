#! /bin/sh
#
# Automate the process of rebuilding all environments on a monolithic master using the nuclear option:
# https://github.com/puppetlabs/pe-file-sync/blob/everett/documentation/troubleshooting.md
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
echo "This script will completely delete and redeploy all environments without backup!"
echo "            The operation may take up to five minutes to complete."
echo
echo "             Press Control-C now to abort or [enter] to continue."
echo
echo "################################################################################"
echo
read junk

systemctl stop pe-puppetserver

# filesync cache
rm -rf /opt/puppetlabs/server/data/puppetserver/filesync

# r10k cache
rm -rf /opt/puppetlabs/server/data/code-manager/git

# code manager worker thread caches
rm -rf /opt/puppetlabs/server/data/code-manager/worker-caches
rm -rf /opt/puppetlabs/server/data/code-manager/cache

# possibly stale environment codebases
rm -rf /etc/puppetlabs/code/*
rm -rf /etc/puppetlabs/code-staging/environments

systemctl start pe-puppetserver
puppet code deploy --all --wait

