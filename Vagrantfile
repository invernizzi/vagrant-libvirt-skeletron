#  vim: set ft=ruby :
require_relative '.vagrant_utils.rb'

# Hosts -----------------------------------------------------------------------
as_my_virtual_machines do |config|

  # The simplest VM
  define_a_vm config, name: "test", host: 'veni', manifest: 'test.pp'

  # A more customized VM
  define_a_vm config, name: "big-mama", host: 'veni', manifest: 'test.pp', memory: 4096, cpus: 10, ip: '192.168.48.196'
end
# -----------------------------------------------------------------------------
