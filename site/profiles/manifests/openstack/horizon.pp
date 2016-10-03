class profile::openstack::horizon () {
  class { 'memcached':
    listen_ip => '127.0.0.1',
    tcp_port  => '11211',
    udp_port  => '11211',
  }

  class { '::horizon':
    cache_server_ip   => '127.0.0.1',
    cache_server_port => '11211',
    secret_key        => '12345',
    swift             => false,
    django_debug      => 'True',
    api_result_limit  => '2000',
  }

}