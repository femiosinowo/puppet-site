class profiles::messaging::rabbitmq (
  $private_key     = hiera("private_key"),
  $server_certs    = hiera("server_certs"),
  $root_ca         = hiera("root_ca"),
  $intermediate_ca = hiera("intermediate_ca"),
  $ca_bundle       = hiera("ca_bundle"),) {
  #  file { '/etc/rabbitmq/ssl/cacert.pem': source => 'puppet:///modules/profiles/ssl_certs/sensu_ca/cacert.pem', }
  #
  #  file { '/etc/rabbitmq/ssl/cert.pem': source => 'puppet:///modules/profiles/ssl_certs/server/cert.pem', }
  #
  #  file { '/etc/rabbitmq/ssl/key.pem': source => 'puppet:///modules/profiles/ssl_certs/server/key.pem', }
  # $plug
  Exec {
    path => ['/usr/bin'] }

  class { 'erlang': epel_enable => true } ->
  class { 'rabbitmq':
    manage_repos   => true,
    service_manage => true,
    ssl_key        => $private_key,
    ssl_cert       => $server_certs,
    ssl_cacert     => $root_ca,
    ssl            => false,
    # config         => 'profiles/messaging/rabbitmq/rabbitmq.config.erb',
    plugin_dir     => '/etc/rabbitmq/plugins',
    config_additional_variables => {
      'autocluster' => '[{consul_service, "rabbitmq"},{consul_host, "localhost"},{consul_port, "8500"},{cluster_name, "rabbitmq"},{backend,"consul"}]',
      # /var/lib/rabbitmq/
    }
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
  } 
  # plugin

  file { '/usr/lib/rabbitmq/lib/rabbitmq_server-3.3.5/plugins/autocluster-0.6.1.ez':
    ensure => file,
     require => Class['rabbitmq'],
    source => 'puppet:///modules/profiles/messaging/rabbitmq/plugins/autocluster-0.6.1.ez',
  } ~>
  file { '/usr/lib/rabbitmq/lib/rabbitmq_server-3.3.5/plugins/rabbitmq_aws-0.1.2.ez':
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
  } ~> exec { 'systemctl restart  rabbitmq-server; /usr/sbin/rabbitmqctl stop_app ; /usr/sbin/rabbitmqctl start_app': #refreshonly => true,
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