#!/usr/bin/env bash

export VAGRANT_CWD="/c/dev/master/"

vagrant ssh puppet -c  "sudo /opt/puppetlabs/bin/puppet cert clean $1"