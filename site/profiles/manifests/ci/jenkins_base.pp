class profiles::jenkins_base (
  $jenkins_username = hiera('jenkins::jenkins_ui_username'),
  $jenkins_password = hiera('jenkins::jenkins_ui_password')) {
  class { 'jenkins': }

}
