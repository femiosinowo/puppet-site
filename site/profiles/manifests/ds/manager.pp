class profiles::ds::manager (
  $consul_host = hiera('consul::server::ip'),
  $consul_port = hiera('consul::server::port'),
  $bind        = 'tcp://0.0.0.0:3000',) {
  class { 'docker':
    repo_opt         => '',
    # tcp_bind         => $bind,
    socket_bind      => 'unix:///var/run/docker.sock',
    extra_parameters => "--cluster-store=consul://${consul_host}:${consul_port} --cluster-advertise=${::ipaddress_eth0}:2376"
  } ->
#  docker_network { 'swarm-private':
#    ensure           => present,
#    driver           => 'overlay',
#   # extra_parameters => "--cluster-store=consul://${consul_host}:${consul_port} --cluster-advertise=${::ipaddress_eth0}:2376"
#  } ->
  ::docker::run { 'swarm-manager':
    image   => 'swarm',
    ports   => '3000:2375',
    command => "manage consul://${consul_host}:8500/swarm_nodes --strategy spread",
  # drequire => Docker::Run['swarm'],
  } ->
  class { 'docker::compose':
    ensure       => present,
    install_path => '/usr/bin'
  }->
  file { '/root/docker-compose.yml':
    ensure  => file,
    content => template("profiles/ds/registrator.yml.erb"),
  } ->
  docker_compose { '/root/docker-compose.yml': ensure => present, }

}