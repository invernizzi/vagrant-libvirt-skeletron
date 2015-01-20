#!/bin/bash

# Helper functions ------------------------------------------------------------

function execute_on_condition_failed {
    echo "Checking if $1"
    if eval $2 ; then
        echo "Condition satisfied: $1"
    else
        echo "Condition failed: $1 - Updating the system..."
        eval $3
    fi
}
# -----------------------------------------------------------------------------


# Install/check-if-present functions ------------------------------------------

function check_if_apt_cache_is_current {
    if [ "$[$(date +%s) - $(stat -c %Z /var/lib/apt/periodic/update-success-stamp)]" -ge $((24*60*60)) ]; then
        return 1
    else
        return 0
    fi
}

RVM_APT_KEY='409B6B1796C275462A1703113804BB82D39DC0E3'

function check_rvm_key_present {
    sudo gpg --list-keys "$RVM_APT_KEY"
}

function install_rvm_key {
    sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys "$RVM_APT_KEY"
}

function install_rvm {
    sudo \curl -sSL https://get.rvm.io | bash -s stable --ruby  --with-gems="puppet"
}

function install_librarian_puppet {
    sudo apt-get install -y ruby-all-dev  # required by librarian-puppet
    sudo gem install librarian-puppet
}
# -----------------------------------------------------------------------------


# Setup the base machine ------------------------------------------------------

execute_on_condition_failed "Apt cache is current" "check_if_apt_cache_is_current" "sudo apt-get update"
execute_on_condition_failed "Rvm APT key is present" "check_rvm_key_present" "install_rvm_key"
execute_on_condition_failed "Rvm and Puppet are present" "which rvm" "install_rvm"
# Load rvm
source /usr/local/rvm/scripts/rvm
execute_on_condition_failed "Librarian-puppet is present" "which librarian-puppet" "install_librarian_puppet"
execute_on_condition_failed "git is present" "which git" "sudo apt-get install -y git"
