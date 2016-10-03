class profiles::ds::base (
  $consul_host = hiera('consul::server::ip'),
  $consul_port = hiera('consul::server::port'),
  $bind        = "tcp://${::ipaddress_eth1}:2375",) {
  class { 'docker':
    repo_opt         => '',
    tcp_bind         => $bind,
    socket_bind      => 'unix:///var/run/docker.sock',
    extra_parameters => "--cluster-store=consul://${consul_host}:${consul_port} --cluster-advertise=${::ipaddress_eth1}:2376  ",
    labels           => ['type_node=app1', 'stage=production'],
  } ->
  ::docker::run { 'swarm':
    image   => 'swarm',
    command => "join --addr=${::ipaddress_eth1}:2375 consul://${consul_host}:8500/swarm_nodes  ",
  } ->
  class { 'docker::compose':
    ensure       => present,
    install_path => '/usr/bin'
  } ->
  file { '/root/docker-compose.yml':
    ensure  => file,
    content => template("profiles/ds/registrator.yml.erb"),
  } ->
  docker_compose { '/root/docker-compose.yml': ensure => present, }
}