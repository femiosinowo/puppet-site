class roles::rabbitmq () {
  #
  include profiles::stages

  include profiles::messaging::rabbitmq

}