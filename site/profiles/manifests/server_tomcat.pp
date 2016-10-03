class profiles::server_tomcat () {
  class { 'tomcat': }

  class { 'java': }
  tomcat::instance { 'test': source_url => 'http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz' 
    } ->
  tomcat::service { 'default': }

}