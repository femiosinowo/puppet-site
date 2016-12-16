class profiles::messaging::rabbitmq (
  $private_key      = hiera("private_key"),
  $server_certs     = hiera("server_certs"),
  $root_ca          = hiera("root_ca"),
  $intermediate_ca  = hiera("intermediate_ca"),
  $ca_bundle        = hiera("ca_bundle"),
  $rabbitmq_version = '3.6.5',) {
  #  file { '/etc/rabbitmq/ssl/cacert.pem': source => 'puppet:///modules/profiles/ssl_certs/sensu_ca/cacert.pem', }
  #
  #  file { '/etc/rabbitmq/ssl/cert.pem': source => 'puppet:///modules/profiles/ssl_certs/server/cert.pem', }
  #
  #  file { '/etc/rabbitmq/ssl/key.pem': source => 'puppet:///modules/profiles/ssl_certs/server/key.pem', }
  # $plug
  Exec {
    path => ['/usr/bin'] }

  exec { 'rpm --import https://packages.erlang-solutions.com/rpm/erlang_solutions.asc':
    refreshonly => true,
    require     => Class['yum']
  } ->
  package { 'erlang': ensure => latest } ->
  class { 'rabbitmq':
    version        => $rabbitmq_version,
    service_manage => true,
    #    ssl_key        => $private_key,
    #    ssl_cert       => $server_certs,
    #    ssl_cacert     => $root_ca,
    ssl            => false,
    # config         => 'profiles/messaging/rabbitmq/rabbitmq.config.erb',
    plugin_dir     => '/etc/rabbitmq/plugins',
    erlang_cookie  => 'ABCIDEJIJKLMOODPK',
    wipe_db_on_cookie_change    => true,
    cluster_partition_handling  => 'autoheal',
    config_cluster => false,
    config_additional_variables => {
      'autocluster' => '[{consul_service, "rabbitmq"},{consul_host, "localhost"},{consul_port, "8500"},{cluster_name,
        "rabbitmq"},{backend,"consul"}]',
    }
  } ->
  rabbitmq_user { 'admin':
    admin    => true,
    password => 'admin'
  } ->
  rabbitmq_user_permissions { 'admin@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  } ->
  rabbitmq_vhost { '/sensu': ensure => present, } ->
  rabbitmq_user { 'sensu':
    admin    => true,
    password => 'sensu'
  } ->
  rabbitmq_user_permissions { 'sensu@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  } ->
  #  rabbitmq_vhost { '/mcollective': ensure => present, } ->
  #  rabbitmq_user { 'mcollective':
  #    admin    => true,
  #    password => 'mcollective'
  #  } ->
  #  rabbitmq_user_permissions { 'mcollective@/mcollective':
  #    configure_permission => '.*',
  #    read_permission      => '.*',
  #    write_permission     => '.*',
  #  } ->
  #  rabbitmq_user_permissions { 'admin@/mcollective':
  #    configure_permission => '.*',
  #    read_permission      => '.*',
  #    write_permission     => '.*',
  #  } ->
  rabbitmq_vhost { '/logstash': ensure => present, } ->
  rabbitmq_user { 'logstash':
    admin    => true,
    password => 'logstash'
  } ->
  rabbitmq_user_permissions { 'logstash@/logstash':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  } ->
  rabbitmq_exchange { 'exchangelogstash@/logstash':
    ensure      => present,
    user        => 'logstash',
    password    => 'logstash',
    type        => 'topic',
    internal    => false,
    auto_delete => false,
    durable     => true,
    arguments   => {
      hash-header => 'message-distribution-hash'
    }
  } ->
  #  rabbitmq_exchange { 'exchange_broadcast@/mcollective':
  #    ensure      => present,
  #    user        => 'mcollective',
  #    password    => 'mcollective',
  #    type        => 'topic',
  #    internal    => false,
  #    auto_delete => false,
  #    durable     => true,
  #    arguments   => {
  #      hash-header => 'message-distribution-hash'
  #    }
  #  } ->
  #  rabbitmq_exchange { 'exchange_directed@/mcollective':
  #    ensure      => present,
  #    user        => 'mcollective',
  #    password    => 'mcollective',
  #    type        => 'direct',
  #    internal    => false,
  #    auto_delete => false,
  #    durable     => true,
  #    arguments   => {
  #      hash-header => 'message-distribution-hash'
  #    }
  #  } ->
  rabbitmq_queue { 'queuelogstash@/logstash':
    ensure      => present,
    user        => 'logstash',
    password    => 'logstash',
    durable     => true,
    auto_delete => false,
  #  arguments   => {
  #    x-message-ttl => 123,
  #    x-dead-letter-exchange => 'other'
  #  },
  } ->
  rabbitmq_binding { 'exchangelogstash@queuelogstash@/logstash':
    ensure           => present,
    user             => 'logstash',
    password         => 'logstash',
    destination_type => 'queue',
    routing_key      => 'logs.%{host}',
    arguments        => {
    }
    ,
  }

  # plugin

  file { "/usr/lib/rabbitmq/lib/rabbitmq_server-${rabbitmq_version}/plugins/autocluster-0.6.1.ez":
    ensure  => file,
    require => Class['rabbitmq'],
    source  => 'puppet:///modules/profiles/messaging/rabbitmq/plugins/autocluster-0.6.1.ez',
  } ~>
  file { "/usr/lib/rabbitmq/lib/rabbitmq_server-${rabbitmq_version}/plugins/rabbitmq_aws-0.1.2.ez":
    ensure => file,
    source => 'puppet:///modules/profiles/messaging/rabbitmq/plugins/rabbitmq_aws-0.1.2.ez',
    before => Exec['/usr/sbin/rabbitmq-plugins enable autocluster']
  } ~>
  # rabbitmq_plugin { 'autocluster': ensure => present, }

  exec { '/usr/sbin/rabbitmq-plugins enable autocluster':
    environment => "HOME=/root",
    refreshonly => true,
  # before      => File['/etc/rabbitmq/rabbitmq.config'],
  # notify      => Class['rabbitmq::service'],
  } ~>
  exec { 'restart rabbitmq services':
    command     => 'systemctl restart  rabbitmq-server; /usr/sbin/rabbitmqctl stop_app ; /usr/sbin/rabbitmqctl start_app',
    refreshonly => true,
  }
  #  file { '/etc/rabbitmq/rabbitmq.config':
  #    content => template('profiles/messaging/rabbitmq/rabbitmq.config.erb'),
  #    ensure  => file,
  #    # source => 'puppet:///modules/profiles/messaging/rabbitmq/plugins/rabbitmq_aws-0.1.2.ez',
  #    before  => Exec['restart  rabbitmq-server'],
  #     notify   => Class['rabbitmq::service'],
  #  } ~>
  #
}