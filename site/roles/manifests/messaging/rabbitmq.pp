class roles::messaging::rabbitmq () {
  #
  include profiles::stages

  include profiles::messaging::rabbitmq

}