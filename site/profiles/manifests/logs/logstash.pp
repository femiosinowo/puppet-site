class profiles::logs::logstash (
  $input              = 'profiles/logstash/server/centos-messages-input.erb',
  $filters            = ['profiles/logstash/server/centos-messages-filter.erb'],
  $output             = 'profiles/logstash/server/centos-messages-output.erb',
  $private_key        = hiera("private_key"),
  $server_certs       = hiera("server_certs"),
  $root_ca            = hiera("root_ca"),
  $intermediate_ca    = hiera("intermediate_ca"),
  $ca_bundle          = hiera("ca_bundle"),
  $elastic_search_url = "http://${::fqdn}:9200",
  $rabbitmq_service   = "rabbitmq.service.consul"
  #
  ) {
  ##

  class { '::logstash':
    ensure       => 'present',
    java_install => true,
    package_url  => 'https://download.elastic.co/logstash/logstash/packages/centos/logstash-2.3.4-1.noarch.rpm',
  # require      => File['cert_dir'],
  # before       => Exec['create_certs'],
  # manage_repo  => true,
  # repo_version => '2.2',
  }

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

  logstash::configfile { '/etc/logstash/conf.d/producer.conf': content => template('profiles/logstash/producer.conf.erb'), }

  logstash::configfile { '/etc/logstash/conf.d/consumer.conf': content => template('profiles/logstash/consumer.conf.erb'), }

  logstash::plugin { 'logstash-input-beats': }

  logstash::plugin { 'logstash-output-rabbitmq': }

  logstash::plugin { 'logstash-input-rabbitmq': }

}