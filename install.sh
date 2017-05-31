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
TOUCH=/bin/touch

echo "copying files...."

$CP -R 5.0/remotes/vmm/vcloud $REMOTES_DIR/vmm/
$CP -R 5.0/remotes/im/vcloud.d $REMOTES_DIR/im/
$CP -R 5.0/remotes/datastore/vcloud $REMOTES_DIR/datastore/
$CP -R 5.0/remotes/hooks/dv $REMOTES_DIR/hooks/
$CP 5.0/remotes/vmm/vcloud/vcloud_driver.rb /usr/lib/one/ruby

$CHOWN -R oneadmin:oneadmin /var/lib/one/remotes/vmm/vcloud /var/lib/one/remotes/im/vcloud.d /var/lib/one/remotes/datastore/vcloud /var/lib/one/remotes/hooks/dv

$CHMOD -R +x /var/lib/one/remotes/vmm/vcloud /var/lib/one/remotes/im/vcloud.d /var/lib/one/remotes/datastore/vcloud /var/lib/one/remotes/hooks/dv

echo "Finished copying files"

echo "Creating log files"

$TOUCH /var/lib/one/vcloud.log
$CHOWN oneadmin:oneadmin /var/lib/one/vcloud.log

$TOUCH /var/lib/one/rest
$CHOWN oneadmin:oneadmin /var/lib/one/rest

echo "Installing gem dependences...."

if [ -n "`command -v apt-get`" ]; then
    MANAGER=apt-get
    $MANAGER update
else
    MANAGER=yum
fi

$MANAGER install -y make g++ ruby-dev zlib1g-dev liblzma-dev

echo "Dependences installed"

echo "Introduce your vCloud Director version: "
echo "1. vCloud Director 5.5"
echo "2. vCloud Director 8"

read version

echo "Installing gem...."

if [ $version -eq 2 ]; then
    gem install ruby_vcloud8_sdk-*.gem 
else
    gem install ruby_vcloud5.5_sdk-*.gem 
fi

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