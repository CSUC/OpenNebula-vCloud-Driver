#!/bin/bash

echo "Starting vCloud Driver installation..."

set -e

if [ -z "${ONE_LOCATION}" ]; then
    REMOTES_DIR=/var/lib/one/remotes
else
    REMOTES_DIR=$ONE_LOCATION/var/remotes
fi

# Squash aliases
CP=/bin/cp
MKDIR=/bin/mkdir
CHOWN=/bin/chown
CHMOD=/bin/chmod

echo "copying files...."

$CP -R 5.0/remotes/vmm/vcloud $REMOTES_DIR/vmm/
$CP -R 5.0/remotes/im/vcloud.d $REMOTES_DIR/im/
$CP -R 5.0/remotes/datastore/vcloud $REMOTES_DIR/datastore/
$CP -R 5.0/remotes/hooks/dv $REMOTES_DIR/hooks/
$CP 5.0/remotes/vmm/vcloud/vcloud_driver.rb /usr/lib/one/ruby

$CHOWN -R oneadmin:oneadmin /var/lib/one/remotes/vmm/vcloud /var/lib/one/remotes/im/vcloud.d /var/lib/one/remotes/datastore/vcloud /var/lib/one/remotes/hooks/dv

$CHMOD -R +x /var/lib/one/remotes/vmm/vcloud /var/lib/one/remotes/im/vcloud.d /var/lib/one/remotes/datastore/vcloud /var/lib/one/remotes/hooks/dv

echo "Finished copying files"

echo "Installing gem dependences...."

apt-get update

apt-get install -y make g++ ruby-dev zlib1g-dev liblzma-dev

echo "Dependences installed"

echo "Installing gem...."

gem install ruby_vcloud_sdk-*.gem 

echo "Finished gem installation"

echo "Finished installing driver actions"
  
  if [ -z "$(grep -i vCloud /etc/one/oned.conf)" ]; then
    echo ""
    echo "================================================================="
    echo "          vCloud Driver not found in /etc/one/oned.conf"
    echo "Be sure to enable the vCloud Driver driver in /etc/one/oned.conf"
    echo "          Follow the instructions explained in Guide.md"
    echo "================================================================="
    echo ""
fi