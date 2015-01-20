#!/bin/bash
source /usr/local/rvm/scripts/rvm
cd /vagrant/puppet
sudo librarian-puppet install  --verbose
sudo puppet apply --modulepath="`pwd`/modules"  manifests/$1
