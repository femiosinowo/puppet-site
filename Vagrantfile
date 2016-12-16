# -*- mode: ruby -*-
# # vi: set ft=ruby :
 
# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"
 
# Require YAML module
require 'yaml'
 
# Read YAML file with box details
servers = YAML.load_file('servers.yaml')
 

		# Create boxes
		Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

			#config.vm.synced_folder "../puppet-site", "/etc/puppetlabs/code/environments/production/"


			#config.ssh.private_key_path = ".ssh/id"
			#config.ssh.forward_agent = true


			#config.ssh.username = 'root'
			#config.ssh.password = 'vagrant'
			config.ssh.insert_key = 'false'

		  # Iterate through entries in YAML file
		  servers.each do |servers|
			config.vm.define servers["hostname"] do |srv|
			  srv.vm.box = servers["box"]
			  srv.vm.network "private_network", ip: servers["ip"]
			  srv.vm.provision :hosts, :sync_hosts => true
			  srv.vm.hostname =  servers["hostname"] + ".paosin.local"
			  srv.vm.provider :virtualbox do |vb|
				vb.name = servers["hostname"]
				vb.memory = servers["ram"]		
			  end
			  
			  machine = servers["hostname"] + ".paosin.local"
			  
			  if  servers["hostname"] == "puppet"
			    config.vm.synced_folder ".", "/etc/puppetlabs/code/environments/production/",
					:owner => "root",
					:group => "root",
					:mount_options  => ['dmode=755,fmode=755']
			  end
			  
			  serverrole =  servers["server_role"]
			  
			  config.vm.provision :shell, :path => "provision/bootstrap.sh", :args => serverrole
		 	  
			  
				config.trigger.before :destroy do
				  info "Removing " + machine + " certs from puppet "
				  #run_remote  "bash provision/cleanup.sh"
				  run "vagrant ssh puppet -c 'sudo /opt/puppetlabs/bin/puppet cert clean " + machine + "'"
				end
				
 
				
				config.vm.provision "puppet_server" do |puppet|
					puppet.puppet_node = machine
					puppet.puppet_server = "puppet.paosin.local"
					puppet.options = "--verbose  --color=true "
				end
		 
			  
			  
			  
			end
		  end
  
		  config.vm.provision "shell", keep_color:true , inline: <<-SHELL
			 #yum update -y
				#ssh-copy-id -i .ssh/id.pub -p 2200 vagrant@127.0.0.1 
				#sudo echo 'server_role:"+ server_role +"' > /opt/puppetlabs/puppet/cache/facts.d/server_role.yaml
				SHELL
  
	end