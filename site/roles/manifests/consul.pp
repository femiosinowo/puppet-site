class roles::consul () {
  #


  include profiles::stages

  include profiles::monitor::consul

  class { '::profiles::serverspec': stage => testing, }

}