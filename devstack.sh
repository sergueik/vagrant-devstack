#!/bin/sh

# environment variables
OPENSTACK_BRANCH=stable/juno
OPENSTACK_ADM_PASSWORD=devstack

# determine own script path
BASHPATH="`dirname \"$0\"`"              # relative
BASHPATH="`( cd \"$BASHPATH\" && pwd )`"  # absolutized and normalized
echo "run script from $BASHPATH"

export OPENSTACK_BRANCH=$OPENSTACK_BRANCH
export OPENSTACK_ADM_PASSWORD=$OPENSTACK_ADM_PASSWORD

# update system
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -qqy git 

# No module named angular_cookies

# https://ask.openstack.org/en/question/64130/getting-error-while-installing-devstack-juno-release-stacksh/
# apt-get install -qqy npm
# npm install angular-cookies
# the following may be an overkill
# apt-get install python-pbr
# TODO:  update base image
# determine checkout folder

PWD=$(su $OS_USER -c "cd && pwd")
DEVSTACK=$PWD/devstack
# TODO: clone the devstack on the host box
# check if devstack is already there
if [ ! -d "$DEVSTACK" ]
then
  echo "Download devstack into $DEVSTACK"

  # clone devstack
  su $OS_USER -c "cd && git clone -b $OPENSTACK_BRANCH https://github.com/openstack-dev/devstack.git $DEVSTACK"

  echo "Copy configuration"

  # copy localrc settings (source: devstack/samples/localrc)
  echo "copy config from $BASHPATH/config/localrc to $DEVSTACK/localrc"
  cp $BASHPATH/config/localrc $DEVSTACK/localrc
  chown $OS_USER:$OS_USER $DEVSTACK/localrc
fi

# start devstack
echo "Start Devstack"
su $OS_USER -c "cd $DEVSTACK && ./stack.sh"

# see also https://github.com/grimmtheory/vagrant-devstack/blob/master/Vagrantfile.stable
