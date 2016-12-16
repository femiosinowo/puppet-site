class profiles::tomcatp () {
  
  #
  class { 'java': }

  tomcat::install { '/opt/tomcat8': 
  source_url => 'https://www.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz' 
    }

  tomcat::instance { 'tomcat8-first':
    catalina_home => '/opt/tomcat8',
    catalina_base => '/opt/tomcat8/first',
  }

}