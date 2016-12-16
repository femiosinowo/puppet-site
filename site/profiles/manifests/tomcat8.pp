class profiles::tomcat8 () {
  #
  class { 'java': }

  #  tomcat::install { '/opt/tomcat8':
  #  source_url => 'http://apache.claz.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz'
  #    }
  #
  #  tomcat::instance { 'tomcat8':
  #    catalina_home => '/opt/tomcat8',
  #    catalina_base => '/opt/tomcat8/',
  #    manage_service => true,
  #  }

  tomcat::install { '/opt/tomcat': source_url => 'http://ftp.wayne.edu/apache/tomcat/tomcat-8/v8.0.37/bin/apache-tomcat-8.0.37.tar.gz', 
  } ->
  #  file { 'my tomcat user files':
  #    ensure  => file,
  #    path    => '/opt/tomcat/conf/tomcat-users.xml',
  #    content => template('profiles/tomcat-users.xml.erb'),
  #  # notify  => Service['tomcat']
  #  } ->

  tomcat::config::server::tomcat_users { 'create admin role':
    ensure        => present,
    catalina_base => '/opt/tomcat',
    element       => 'role',
    element_name  => 'admin',
  } ->
  tomcat::config::server::tomcat_users { 'create admin gui role':
    ensure        => present,
    catalina_base => '/opt/tomcat',
    element       => 'role',
    element_name  => 'admin-gui',
  } ->
  tomcat::config::server::tomcat_users { 'create manager role':
    ensure        => present,
    catalina_base => '/opt/tomcat',
    element       => 'role',
    element_name  => 'manager-gui',
  } ->
  tomcat::config::server::tomcat_users { 'create admin user':
    ensure        => present,
    catalina_base => '/opt/tomcat',
    element       => 'user',
    element_name  => 'tomcat',
    password      => 'asdf',
    roles         => ['admin', 'admin-gui', 'manager-gui'],
  } ->
  tomcat::config::server::tomcat_users { 'create femi user':
    ensure        => present,
    catalina_base => '/opt/tomcat',
    element       => 'user',
    element_name  => 'femi',
    password      => 'asdf',
    roles         => ['admin', 'admin-gui', 'manager-gui'],
  } ->
  tomcat::instance { 'default': catalina_home => '/opt/tomcat', }

  tomcat::war { 'sample.war':
    catalina_base => '/opt/tomcat',
    war_source    => 'https://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war',
  }

  #  ->
  #  file { 'my tomcat user files':
  #    ensure  => file,
  #    path    => '/opt/tomcat/conf/tomcat-users.xml',
  #    content => template('profiles/tomcat-users.xml.erb'),
  #    #notify  => Service['tomcat']
  #  } ~>
  #  tomcat::service { 'default':
  #    e
  #  }
  #   exec{'git clone httpsdfwafwf':
  #    cwd => '/opt/tomcat8/first',
  #}
  #
}