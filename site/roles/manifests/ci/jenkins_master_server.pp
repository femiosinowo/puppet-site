class roles::ci::jenkins_master_server () {
  
  #
  #
  include profiles::stages
  include profiles::ci::jenkins_master

}