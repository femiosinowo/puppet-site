class profiles::ds::cluster1 ($consul_host = hiera('consul::server::ip'), $consul_port = hiera('consul::server::port')) {
  include 'docker'

  class { 'docker::compose': ensure => present, }



  file { '/root/docker-compose.yml':
    ensure  => file,
    content => template("profiles/ds/registrator.yml.erb"),
  } ->
  docker_compose { '/root/docker-compose.yml':
    ensure => present,
#    scale  => {   'compose_test' => 2,    }
#    ,
  }->

  ::docker::run { 'swarm':
    image   => 'swarm',
    command => "join --addr=${::ipaddress_eth0}:2375 consul://${consul_host}:8500/swarm_nodes",
   # require => Docker::Compose['/root/docker-compose.yml']
  }->

  ::docker::run { 'swarm-manager':
    image   => 'swarm',
    ports   => '3000:2375',
    command => "manage consul://${::ipaddress_eth0}:8500/swarm_nodes",
    require => Docker::Run['swarm'],
  }
  #  class { 'docker_swarm':
  #    backend       => 'consul',
  #    backend_ip    => $consul_host,
  #    backend_port  => $consul_port,
  #    advertise_int => $::ipaddress_eth0,
  #  }
  #
  #  #  swarm_cluster { 'cluster 1':
  #  #    ensure       => present,
  #  #    backend      => 'consul',
  #  #    cluster_type => 'join',
  #  #    port         => $consul_port,
  #  #    address      => $consul_host,
  #  #    path         => 'swarm'
  #  #  }
  #  swarm_cluster { 'cluster1':
  #    ensure       => present,
  #    backend      => 'consul',
  #    cluster_type => 'manage',
  #    port         => $consul_port,
  #    address      => $consul_host,
  #    advertise    => $::ipaddress_eth0,
  #    path         => 'swarm',
  #  }
  #
  # #  swarm_run { 'logstash':
  #  #    ensure  => present,
  #  #    image   => 'scottyc/logstash',
  #  #    network => 'swarm-private',
  #  #    ports   => ['9998:9998', '9999:9999/udp', '5000:5000', '5000:5000/udp'],
  #  #    env     => ['ES_HOST=elasticsearch', 'ES_PORT=9200'],
  #  #    command => 'logstash -f /opt/logstash/conf.d/logstash.conf --debug',
  #  #    #require => Class['config::swarm']
  #  #  }
  #
  #  #  file { '/root/docker-compose.yml':
  #  #    ensure  => file,
  #  #    content => template("profiles/ds/registrator.yml.erb"),
  #  #  } ->
  #  #  docker_compose { 'swarm app':
  #  #    ensure => present,
  #  #    source => '/root',
  #  #    scale  => ['1']
  #  #  }
  #
  #  # docker::image { 'eboraas/apache-php': }
  #
  #  #  docker::run { 'helloworld': image => 'eboraas/apache-php',
  #  # command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  #
  #
  #  #  swarm_cluster {'cluster 1':
  #  #    ensure       => present,
  #  #    backend      => 'consul',
  #  #    cluster_type => 'manage',
  #  #    port         => $consul_port,
  #  #    address      => $consul_host,
  #  #    advertise    => $::ipaddress_enp0s8,
  #  #    path         => 'swarm',
  #  #    }
  #
  #  #    docker_network { 'swarm-private':
  #  #    ensure => present,
  #  #    create => true,
  #  #    driver => 'overlay',
  #  #    }
}