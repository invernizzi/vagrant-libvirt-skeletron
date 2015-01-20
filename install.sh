#!/bin/bash -e

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

function install_virtualbox {
    wget http://download.virtualbox.org/virtualbox/4.3.20/virtualbox-4.3_4.3.20-96996~Ubuntu~raring_amd64.deb -O /tmp/virtualbox.deb
    sudo dpkg -i /tmp/virtualbox.deb
}

function install_vagrant {
    # The one in the repositories is too old
    wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.5_x86_64.deb -O /tmp/vagrant.deb
    sudo dpkg -i /tmp/vagrant.deb
}

function check_if_vagrant_elem_present {
    if [[ -z $(vagrant $1 list|grep $2) ]] ; then
        return 1
    else
        return 0
    fi
}

function install_ubuntu_box {
    vagrant box add trusty64 https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box
}

# -----------------------------------------------------------------------------

echo '## Installing required software'
execute_on_condition_failed 'Virtualbox is present' 'which VirtualBox' 'install_virtualbox'
execute_on_condition_failed 'vagrant is present' 'which vagrant' 'install_vagrant'
execute_on_condition_failed 'Ubuntu box present' 'check_if_vagrant_elem_present box trusty' 'install_ubuntu_box'
execute_on_condition_failed 'Vagrant-libvirt present' 'check_if_vagrant_elem_present plugin libvirt' 'vagrant plugin install vagrant-libvirt'
execute_on_condition_failed 'Vagrant-mutate present' 'check_if_vagrant_elem_present plugin mutate' 'vagrant plugin install vagrant-mutate'
execute_on_condition_failed 'qemu-utils is present' 'which qemu-utils' 'sudo apt-get -y install qemu-utils'
echo '## All done! Enjoy!'
