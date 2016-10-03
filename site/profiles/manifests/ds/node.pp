class profiles::ds::node (
  $consul_host = hiera('consul::server::ip'),
  $consul_port = hiera('consul::server::port'),
  $bind        = 'tcp://0.0.0.0:2375',) {
  include profiles::ds::base



}