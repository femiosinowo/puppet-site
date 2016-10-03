#!/bin/bash

r10k deploy environment production -pv
rm -rf /etc/puppetlabs/code/environments/production/modules
cp -rf /etc/puppetlabs/puppet/code/environments/production/modules /etc/puppetlabs/code/environments/production/
rm -rf /etc/puppetlabs/puppet/code/environments/production/modules
