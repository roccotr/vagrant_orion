# -*- mode: ruby -*-
# vi: set ft=ruby :

def parse_vagrant_config(
  config_file=File.expand_path(File.join(File.dirname(__FILE__), 'vagrant.yml'))
)
  require 'yaml'
  config = {
    'http_proxy'      => ENV.fetch('HTTP_PROXY', ''),
    'vm_memory'       => 1024,
    'vm_cpus'         => 1
  }
  if File.exists?(config_file)
    overrides = YAML.load_file(config_file)
    config.merge!(overrides)
  end
  puts "Using configuration: #{config.inspect}"
  config
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  v_config = parse_vagrant_config
  #config.vm.box = "ubuntu/trusty64"
  config.vm.box = "debian/jessie64"
  config.vm.hostname = "dockerhost"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = v_config['vm_memory']
    vb.cpus = v_config['vm_cpus']
  end

  config.vm.provision :shell do |shell|
    proxy_option = v_config['http_proxy'].nil? || v_config['http_proxy'].empty? ? '' : "--proxy #{v_config['http_proxy']}"
    bootstrap_opts = "--basedir /vagrant --user vagrant #{proxy_option}"
    shell.inline = "/vagrant/provision/bootstrap.sh #{bootstrap_opts}"
  end
end
