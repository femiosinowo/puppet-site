class profiles::logs::logstash (
  $input   = 'profiles/logstash/server/centos-messages-input.erb',
  $filters = ['profiles/logstash/server/centos-messages-filter.erb'],
  $output  = 'profiles/logstash/server/centos-messages-output.erb',) {
  file { '/etc/pki/tls/certs/logstash-forwarder.crt':
    ensure  => file,
    source  => "puppet:///modules/profiles/logstash/logstash-forwarder.crt",
    alias   => 'cert_file',
    require => File['cert_dir'],
  }

  #  class { selinux:
  #    mode => 'disabled',
  #    type => 'targeted',
  #  }

  file { '/etc/pki/tls/private/logstash-forwarder.key':
    ensure  => file,
    source  => "puppet:///modules/profiles/logstash/logstash-forwarder.key",
    require => File['cert_dir'],
  }

  file { '/etc/pki/tls/certs':
    ensure => directory,
    group  => root,
    alias  => 'cert_dir',
    before => File['cert_file'],
  }

  class { '::logstash':
    ensure       => 'present',
    java_install => true,
    package_url  => 'https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.3.4-1.noarch.rpm',
  # require      => File['cert_dir'],
  # before       => Exec['create_certs'],
  # manage_repo  => true,
  # repo_version => '2.2',
  }

#  profiles::defines::plugchecksensu { 'fs-check':
#    pluginname => 'sensu-plugins-filesystem-checks',
#    command    => 'check-dir-count.rb'
#  }

  #  profile::plugchecksensu { 'fs-check':
  #    pluginname => ' sensu-plugins-filesystem-checks',
  #    command    => 'check-dir-count.rb'
  #  }
  #  logstash::configfile { 'input':
  #    content => template($input),
  #    order   => 10,
  #  }
  #
  #  each($filters) |$value| {
  #    logstash::configfile { $filters:
  #      content => template($value),
  #      order   => 20,
  #    }
  #  }
  #
  #  logstash::configfile { 'output':
  #    content => template($output),
  #    order   => 30,
  #  }

  logstash::configfile { '/etc/logstash/conf.d/config.conf': content => template('profiles/logstash/config.conf.erb'), }

  # logstash::plugin { 'logstash-input-beats': }
  logstash::plugin { 'logstash-input-beats': }

  #  exec { 'create_certs':
  #    require => File['cert_dir'],
  #    path    => "/usr/bin:/usr/sbin:/bin",
  #    command => 'openssl req -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout /etc/pki/tls/private/logstash-forwarder.key
  #    -out /etc/pki/tls/certs/logstash-forwarder.crt',
  #  }
}