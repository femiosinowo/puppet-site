class roles::ci(){
  stage { 'testing': }
#	include profile::users
#	include profile::tomcat
#	include profile::jenkins
}
