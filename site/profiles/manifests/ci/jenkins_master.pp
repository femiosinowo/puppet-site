class profiles::ci::jenkins_master (
  $jenkins_username = hiera('jenkins::jenkins_ui_username'),
  $jenkins_password = hiera('jenkins::jenkins_ui_password'),

  #
  ) {
  include jenkins
  include jenkins::master

  create_resources('jenkins::plugin', hiera_hash('jenkins::plugins'))
  # jenkins::plugin { 'git': }
}
