# vagrant-libvirt-skeletron

This is the base project I use every time I need to run a big experiment, with many VMs running on multiple KVM/libvirt hosts.
On every VM, we apply a puppet manifest, without the need of a puppet master.



## Add a VM

You just need to edit two files, [Vagrantfile](Vagrantfile), and [puppet/manifests](puppet/manifests)`/your_manifest.pp`.


### Vagrantfile
First , open your [Vagrantfile](Vagrantfile):

```ruby
require_relative '.vagrant_utils.rb'

# Hosts -----------------------------------------------------------------------
as_my_virtual_machines do |config|
  define_a_vm config, name: "test", host: 'veni', manifest: 'test.pp'
end
# -----------------------------------------------------------------------------
```

It defines a VM named `test`, running on KVM host `veni`, on which to run the
puppet script `test.pp` (which is in `puppet/manifests`).

If you want to add en external ip to the VM, simply pass a `ip:
'192.168.0.100'` argument to the `define_a_vm` line.

### Puppet

Add your Puppet manifest in `puppet/manifests`. You can use Puppet modules too,
that you need to specify in [puppet/Puppetfile](puppet/Puppetfile). Your custom
modules should go in [puppet/custom_modules](puppet/custom_modules). You’ll
find examples there.

Note that you don't need to set up a Puppet master, just a manifest will do.


## Install

Simply run

```ruby
./install.sh
```

To install all the software you need to run this. This assumes you are either
on Debian or Ubuntu (12.04 and forward, I’m using 14.04).
