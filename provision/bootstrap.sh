#!/usr/bin/env bash

#create facts
sudo mkdir -p /etc/facter/facts.d
sudo /bin/echo "server_role: $1" > /etc/facter/facts.d/server_role.yaml 

#sudo /opt/puppetlabs/bin/puppet agent -t