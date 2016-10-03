#!/bin/bash
PUPPET_ROLE=$1
NODE_NAME=$2

rm -rf /usr/local/serverspec/properties.yml
cp /tmp/properties.yml /usr/local/serverspec/
mv /usr/local/serverspec/$PUPPET_ROLE /usr/local/serverspec/${NODE_NAME}
sed -i "41s/.*/      t.pattern='${NODE_NAME}\/*_spec.rb'/" /usr/local/serverspec/Rakefile
cd /usr/local/serverspec && /usr/local/share/gems/gems/rake-10.5.0/bin/rake spec
mv /usr/local/serverspec/${PUPPET_ROLE}_report.xml /usr/local/serverspec/${NODE_NAME}-report.xml
