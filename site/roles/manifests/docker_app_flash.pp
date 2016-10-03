class roles::docker_app_flash(){
  stage { 'testing': }
  include profiles::web::app_server1
  
}