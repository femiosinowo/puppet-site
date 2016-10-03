class roles::docker_swarm_manager () {
  stage { 'testing': }

  class { 'profiles::ds::apps::app1': }

  class { 'profiles::ds::manager': }

}