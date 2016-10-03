class profiles::monitor::sensu_server ($sensu_server_ip = hiera('sensu::server_ip') ,) {
 selinux::boolean { 'named_tcp_bind_http_port': }
 selinux::boolean{'postfix_local_write_mail_spool':}

  $uchiwa_api_config = [{
      install_repo => true,
      name         => 'Site-1',
      host         => $sensu_server_ip,
      ssl          => false,
      insecure     => true,
      port         => 4567,
      path         => '',
      timeout      => 10
    }
    ]

  file { '/etc/rabbitmq/ssl/cacert.pem': source => 'puppet:///modules/profiles/ssl_certs/sensu_ca/cacert.pem', }

  file { '/etc/rabbitmq/ssl/cert.pem': source => 'puppet:///modules/profiles/ssl_certs/server/cert.pem', }

  file { '/etc/rabbitmq/ssl/key.pem': source => 'puppet:///modules/profiles/ssl_certs/server/key.pem', }
  class { 'erlang': epel_enable => true } ->
  class { 'rabbitmq':
    manage_repos => true,
    service_manage    => true,
    ssl_key    => '/etc/rabbitmq/ssl//key.pem',
    ssl_cert   => '/etc/rabbitmq/ssl//cert.pem',
    ssl_cacert => '/etc/rabbitmq/ssl//cacert.pem',
    ssl        => false,
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
  class { 'redis': listen => '127.0.0.1', } ->
  class { 'uchiwa':
    install_repo        => false,
    sensu_api_endpoints => $uchiwa_api_config,
  }

  profiles::defines::reverse_proxy { "reverse_proxy":
    service_name => 'uchiwa',
    port         => '3000'
  }
  # curl http://sensu:sensu@10.0.0.50:4567/info
}
