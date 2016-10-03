class roles::dhs_app1 () {
  stage { 'testing': }

  class { 'profiles::web::dhs_app1': }
}