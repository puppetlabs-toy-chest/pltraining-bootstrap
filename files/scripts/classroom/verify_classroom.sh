#! /bin/sh

source puppetlabs_functions.sh
version

if [ $# -eq 1 ]
then
  if [ $1 != "master" ]
  then
    echo "This script should be run with no arguments."
    echo "('master' is still accepted for backwards compatibility, but it's ignored.)"
    exit 1
  fi
fi
if [ $# -gt 1 ]
then
  echo "This script should be run with no arguments."
  exit 1
fi

echo "Verifying Puppet Training classroom setup:"
echo

###### start running checks ######

check "[ '`hostnamectl --static`' == 'master.puppetlabs.vm' ]"                 \
      "Checking hostname"                                           \
      "You should set the hostname to master.puppetlabs.vm"

check "ping -c1 master.puppetlabs.vm"                              \
      "Checking local hostname resolution"                          \
      "You should have an entry in /etc/hosts for master.puppetlabs.vm"

check "[[ '`grep processor /proc/cpuinfo | wc -l`' -gt '1' ]]"      \
      "Checking core count for classroom Master"                    \
      "You should give the virtual machine for the classroom Master at least two cores"

check "[[ \"`awk '/MemTotal/{print $2}' /proc/meminfo`\" -ge '8000000' ]]"   \
      "Checking available memory for classroom Master"              \
      "The classroom Master should have at 8GB (8192MB) of memory. You can try it on 6GB, but it's not recommended."

DEFAULT='$1$jrm5tnjw$h8JJ9mCZLmJvIxvDLjw1M/'  # 'puppet'
check "[[ '$(awk -F ':' '/^root/{print $2}' /etc/shadow)' != '$DEFAULT' ]]"  \
      "Verifying that the default password has been changed"        \
      "You should change root's password before proceeding"

check "ntpdate -u pool.ntp.org"                                       \
      "Attempting to synchronize time..."                           \
      "Network time server unavailable. You should run class in offline mode"
