class profiles::ds::apps::app1 () {
  include wget

  file { '/root/app1/': ensure => directory, }
#  wget::fetch { "download helloworld":
#    source      => 'http://54.209.251.243/artifactory/cicdpipeline-snapshot-local/com/governmentcio/helloworld/0.0.1-SNAPSHOT/helloworld-0.0.1-20160718.184449-108.war',
#    destination => '/root/app1/helloworld.war',
#    timeout     => 0,
#    verbose     => false,
#  } ->
  file { '/usr/local/bin/getwarfile.sh':
    ensure  => file,
    content => template("profiles/ds/apps/app1/getwarfile.sh.erb"),
    path    => '/usr/local/bin/getwarfile.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0744', # Use 0700 if it is sensitive
    notify  => Exec['download helloworld'],
   
  }

  exec { 'download helloworld':
    command   => '/usr/local/bin/getwarfile.sh',
    logoutput => true,
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin',
    require   => File['/usr/local/bin/getwarfile.sh'],
  }

  file { '/root/app1/Dockerfile':
    ensure  => file,
    content => template("profiles/ds/apps/app1/Dockerfile.erb"),
  } -> file { '/root/app1/tomcat-users.xml':
    ensure  => file,
    content => template("profiles/ds/apps/app1/tomcat.users.xml.erb"),
  } ->
  file { '/root/app1/docker-compose.yml':
    ensure  => file,
    content => template("profiles/ds/apps/app1/docker-compose.yaml.erb"),
  } ->
  docker::image { 'app1':
    docker_dir => '/root/app1/',
    # docker_file => '/root/app1/Dockerfile',
    subscribe  => File['/root/app1/Dockerfile'],
  } ->
  exec { 'kill existing apps':
    command   => 'docker-compose  -H :3000 kill && docker-compose  -H :3000 rm -f',
    logoutput => true,
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin',
    # refreshonly => true,
    before    => Docker_compose['/root/app1/docker-compose.yml'],
  } ->
  docker_compose { '/root/app1/docker-compose.yml':
    ensure  => present,
    scale   => {
      'myapp' => 2,
    }
    ,
    options => '-H :3000 '
  }

}