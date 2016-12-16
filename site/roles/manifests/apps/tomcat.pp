class roles::apps::tomcat(){
  include profiles::stages
  include profiles::web::tomcat
  
}