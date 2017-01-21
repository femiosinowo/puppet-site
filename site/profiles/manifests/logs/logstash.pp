class profiles::logs::logstash (
  $input              = 'profiles/logstash/server/centos-messages-input.erb',
  $filters            = ['profiles/logstash/server/centos-messages-filter.erb'],
  $output             = 'profiles/logstash/server/centos-messages-output.erb',
  $private_key        = hiera("private_key"),
  $server_certs       = hiera("server_certs"),
  $root_ca            = hiera("root_ca"),
  $intermediate_ca    = hiera("intermediate_ca"),
  $ca_bundle          = hiera("ca_bundle"),
  $elastic_search_url = hiera("elasticsearch::url"), # "http://${::fqdn}:9200",
  $rabbitmq_service   = hiera("rabbitmq::host"), # "rabbitmq.service.consul",
  $logstash_input     = hiera("logstash::input"), # 'profiles/logstash/server/centos-messages-input.erb',
  $logstash_filter    = hiera("logstash::filter"), # ['profiles/logstash/server/centos-messages-filter.erb'],
  $logstash_output    = hiera("logstash::output"), # 'profiles/logstash/server/centos-messages-output.erb',
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
  #
  #  logstash::configfile { '/etc/logstash/conf.d/producer.conf': content => template('profiles/logstash/producer.conf.erb'), }
  #
  #  logstash::configfile { '/etc/logstash/conf.d/consumer.conf': content => template('profiles/logstash/consumer.conf.erb'), }

  logstash::configfile { 'input':
    # template => $logstash_input, # 'profiles/logstash/input_redis.erb',
    content => template("${logstash_input}"),
    order   => 10,
  }

#  logstash::configfile { 'filter':
#    content => template("${logstash_filter}"),
#    order   => 20,
#  }

  logstash::configfile { 'output':
    # template => $logstash_output,
    content => template("${logstash_output}"),
    order   => 30,
  }

  logstash::plugin { 'logstash-input-beats': }

  logstash::plugin { 'logstash-output-rabbitmq': }

  logstash::plugin { 'logstash-input-rabbitmq': }

  Exec {
    path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin', }

  file { "/var/cache/logstash":
    ensure => 'directory',
    owner  => 'logstash',
    group  => 'logstash',
  }

#setfacl -m u:logstash:r /var/log/{syslog,auth.log}
  exec { 'let logstash be able to read logs': command => "chmod o+r /var/log/messages", }

  #  $logstash_configs = hiera('logstash_configs', {
  #  }
  #  )
  #  create_resources('logstash::configfile', $logstash_configs)
}