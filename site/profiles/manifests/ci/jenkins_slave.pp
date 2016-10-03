class profiles::jenkins_slave (
  $jenkins_ui_user   = hiera('jenkins::jenkins_ui_user'),
  $jenkins_ui_pass   = hiera('jenkins::jenkins_ui_pass'),
  $jenkins_masterurl = hiera('jenkins::masterurl')) {
  class { 'jenkins::slave':
    masterurl => $jenkins_masterurl, # 'http://jenkins-master1.paosin.local:8080',
    ui_user   => $jenkins_ui_user, 
    ui_pass   => $jenkins_ui_pass,
  }  

}
