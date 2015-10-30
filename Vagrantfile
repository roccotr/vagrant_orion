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
ANSIBLE_PLAYBOOK = ENV['ANSIBLE_PLAYBOOK'] || "provision/site.yml"
BOX_MEM = ENV['BOX_MEM'] || "1536"
BOX_NAME =  ENV['BOX_NAME'] || "centos/7"
CLUSTER_HOSTS = ENV['CLUSTER_HOSTS'] || "provision/hosts"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  v_config = parse_vagrant_config
  #config.vm.box = "ubuntu/trusty64"
  #config.vm.box = "debian/jessie64"
  #config.vm.box = BOX_NAME
  #config.vm.hostname = "orionhost"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = v_config['vm_memory']
    vb.cpus = v_config['vm_cpus']
  end


  # centos 6:
  #config.vm.define 'centos' do |c|
  #  c.vm.network "private_network", ip: "192.168.100.4"
  #  c.vm.box = "centos65-x86_64-20140116"
  #  c.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
  #  c.vm.provision "shell" do |s|
  #    s.inline = "yum update gmp; yum install ansible -y"
  #    s.privileged = true
  #  end
  #end

  # centos 7:
  config.vm.define 'centos7' do |c|
    #c.vm.network "private_network", ip: "192.168.100.5"
    c.vm.box = "centos/7"
    c.vm.provision "shell" do |s|
      s.inline = "yum install -y epel-release; yum install -y ansible"
      s.privileged = true
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "provision/site.yml"
    #ansible.inventory_path = CLUSTER_HOSTS
    #ansible.limit = "all"
  end

  #config.vm.provision :ansible do |ansible|
   #ansible.inventory_path = CLUSTER_HOSTS
   # Extra Ansible variables can be defined here
   #ansible.extra_vars = {
    #couchbase_server_ram: "1190",
     # Example variable overrides which will get passed in the same as
     # `ansible-playbook --extra-vars`
     # couchbase_server_local_package: true,
     # couchbase_server_debian_ee_version: "",
     # couchbase_server_debian_ee_package: "",
     # couchbase_server_debian_ee_url: "",
     # couchbase_server_debian_ee_sha256: "",
   #}
   #ansible.playbook = ANSIBLE_PLAYBOOK
   #ansible.limit = "all"
  #end

  #config.vm.provision :shell do |shell|
    #proxy_option = v_config['http_proxy'].nil? || v_config['http_proxy'].empty? ? '' : "--proxy #{v_config['http_proxy']}"
    #bootstrap_opts = "--basedir /vagrant --user vagrant #{proxy_option}"
    #shell.inline = "/vagrant/provision/bootstrap.sh #{bootstrap_opts}"
  #end
end
