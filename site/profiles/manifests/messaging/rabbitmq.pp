class profiles::messaging::rabbitmq () {
  file { '/etc/rabbitmq/ssl/cacert.pem': source => 'puppet:///modules/profiles/ssl_certs/sensu_ca/cacert.pem', }

  file { '/etc/rabbitmq/ssl/cert.pem': source => 'puppet:///modules/profiles/ssl_certs/server/cert.pem', }

  file { '/etc/rabbitmq/ssl/key.pem': source => 'puppet:///modules/profiles/ssl_certs/server/key.pem', }
  class { 'erlang': epel_enable => true } ->
  class { 'rabbitmq':
    manage_repos   => true,
    service_manage => true,
    ssl_key        => '/etc/rabbitmq/ssl//key.pem',
    ssl_cert       => '/etc/rabbitmq/ssl//cert.pem',
    ssl_cacert     => '/etc/rabbitmq/ssl//cacert.pem',
    ssl            => false,
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
}