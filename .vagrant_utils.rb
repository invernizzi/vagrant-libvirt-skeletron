# Backend config --------------------------------------------------------------
#
# -----------------------------------------------------------------------------


# Simplified DSL --------------------------------------------------------------
#
def provision_with_puppet(machine, manifest)
  machine.vm.provision :shell, path: ".setup_base_machine.sh", keep_color: true
  machine.vm.provision :shell, path: ".run_puppet_manifest.sh", args: manifest, keep_color: true
end

def run_on_host(machine, options)
  machine.vm.provider :libvirt do |libvirt|
    libvirt.host = options[:host]
    libvirt.memory = options[:memory] || 2048
    libvirt.cpus = options[:cpus] || 4
  end
end

def set_external_ip(machine, ip)
  machine.vm.network :public_network, ip: ip, dev: "br192", mode: 'bridge'
end

def set_defaults(config, provider)
  config.vm.box = "trusty64"
  case provider.to_sym
  when :virtualbox
  when :libvirt
    ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'
    config.vm.provider :libvirt do |libvirt|
      libvirt.username = 'root'
      libvirt.connect_via_ssh = true
      libvirt.default_prefix = nil
    end
  end
end

def define_a_vm(config, options)
  config.vm.define options[:name] do |machine|
    set_external_ip(machine, options[:ip]) if options[:ip]
    machine.vm.host_name = options[:name]
    run_on_host(machine, options) if options[:host]
    provision_with_puppet(machine, options[:manifest]) if options[:manifest]
  end
end

def provisioning_with(provider)
  Vagrant.configure("2") do |config|
    set_defaults(config, provider)
    yield config
  end
end

# -----------------------------------------------------------------------------

