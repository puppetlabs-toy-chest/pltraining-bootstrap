#! /bin/bash

############# configuration #################
MASTER=classroom.puppet.com
BINDIR=/opt/pltraining/bin
CONFDIR=/opt/pltraining/etc/puppet
VARDIR=/opt/pltraining/var/puppet

while getopts ":u:k:r:h" opt; do
  case $opt in
    k)
      KEY=$OPTARG
      NONINTERACTIVE=1
      ;;
    u)
      EMAIL=$OPTARG
      NONINTERACTIVE=1
      ;;
    r)
      ROLE=$OPTARG
      ;;
    c)
      CHANNEL=$OPTARG
      ;;
    h)
      echo "Options:"
      echo "  * Email address: -u <email address>"
      echo "  * Setup key:     -k <setup key>"
      echo "  * Channel:       -c <stable|beta|testing>"
      echo "  * Machine role:  -r <training|bare|lvm>"
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [[ -v NONINTERACTIVE ]]; then
  if [[ ! -v EMAIL ]]; then echo "Specify your email address with -u <email>"; fi
  if [[ ! -v KEY   ]]; then echo "Specify the setup key with -k <key>";        fi

else
  echo
  echo -n "Enter the setup key: "
  read KEY

  echo -n "What is your Puppet or partner email address? "
  read EMAIL
fi

ARRAY=(${EMAIL//@/ })
DEFAULT="${ARRAY[0]}-$(date +%Y-%m-%d)"

if [[ ! -v NONINTERACTIVE ]]; then
    echo -n "What would you like to call this node [${DEFAULT}]? "
    read NAME
    if [ "$NAME" == "" ]; then NAME=$DEFAULT; fi

    echo
    echo "Using the values:"
    echo "      Email: ${EMAIL}"
    echo "  Node Name: ${NAME}"
    echo "  Setup Key: ${KEY}"
    echo
    echo "Please Ctrl-C and run again if these are not the values you want."
    read junk

else
    NAME=$DEFAULT
fi


# TODO: role selection as a menu:
#         * standard training VM
#         * learning VM
#       Maybe:
#         * bare VM w/o PE installed but all the other tools (for partners who demo the install)
#         * architect student VM (bare VM w/o installer)
#         * student VM? (hopefully we can drop this with the github/gitea workflow)
#         * other?
if [[ ! -v ROLE ]]; then
  ROLE='training'
fi


# TODO: offer alternate channel selection in a menu stable/beta/testing
if [[ ! -v CHANNEL ]]; then
  CHANNEL='stable'
fi


############# now start doing stuffs! #################
if [ -f /etc/redhat-release ]; then
  yum install rubygems ntpdate
elif [ -f /etc/debian_version ]; then
  echo "The Debian platform is support best-effort only."
  echo "       Press [enter] to continue."
  read junk
  apt-get install rubygems ntpdate
else
  echo "Unknown platform... YOLO! You may need to install the"
  echo "following packages on your own for this to succeed."
  echo " * RubyGems"
  echo " * ntpdate"
  echo
  echo " Press [enter] to continue."
  read junk
fi

mkdir -p ${BINDIR}
gem install puppet --bindir ${BINDIR}
ntpdate time.nist.gov

mkdir -p ${CONFDIR}
echo "[main]" > ${CONFDIR}/puppet.conf
echo "  certname = ${NAME}.classroom.puppet.com" >> ${CONFDIR}/puppet.conf
echo "  server = ${MASTER}" >> ${CONFDIR}/puppet.conf
echo "  vardir = ${VARDIR}" >> ${CONFDIR}/puppet.conf

echo "---" > ${CONFDIR}/csr_attributes.yaml
echo "custom_attributes:" >> ${CONFDIR}/csr_attributes.yaml
echo "  challengePassword: ${KEY}" >> ${CONFDIR}/csr_attributes.yaml
echo "extension_requests:" >> ${CONFDIR}/csr_attributes.yaml
echo "  pp_created_by: ${EMAIL}" >> ${CONFDIR}/csr_attributes.yaml
echo "  pp_role: ${ROLE}" >> ${CONFDIR}/csr_attributes.yaml
echo "  pp_environment: ${CHANNEL}" >> ${CONFDIR}/csr_attributes.yaml


${BINDIR}/puppet agent -t --confdir ${CONFDIR}
if [ $? -ne 0 ]; then
  echo "Something broke!"
  echo
  echo "Please examine any error messages above and report issues to the education department."
  echo "   Sometimes issues can be transient. You might try running the installer again."
  echo
  exit 1
fi

# run serverspec tests (which don't yet exist)
classroom validate
if [ $? -ne 0 ]; then
  echo "System validation failed!"
  echo
  echo "Please report failed tests above to the education department."
  echo
  exit 2
fi

echo "All done!"
echo
echo "Classroom VMs are managed by the `classroom` tool. Please run `classroom --help` for usage information."
classroom --help
