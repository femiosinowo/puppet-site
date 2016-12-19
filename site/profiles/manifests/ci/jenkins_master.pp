class profiles::ci::jenkins_master (
  
   $jenkins_username = hiera('jenkins::jenkins_username'),
  $jenkins_password = hiera('jenkins::jenkins_password'),
  
) {
  include jenkins
  include jenkins::master

}
