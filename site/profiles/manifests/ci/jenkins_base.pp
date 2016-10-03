class profiles::jenkins_base (
  $jenkins_username = hiera('jenkins::jenkins_username'),
  $jenkins_password = hiera('jenkins::jenkins_password')) {
  class { 'jenkins': }

}
