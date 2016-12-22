class profiles::ci::jenkins_master (
  $jenkins_username = hiera('jenkins::jenkins_ui_username'),
  $jenkins_password = hiera('jenkins::jenkins_ui_password'),

  #
  ) {
  include jenkins
  include jenkins::master

  jenkins::plugin { 'git': }
}
