class roles::docker_swarm_node () {
  stage { 'testing': }
  include profiles::ds::node
}