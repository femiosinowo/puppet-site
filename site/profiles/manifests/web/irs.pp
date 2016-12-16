class profiles::web::irs ($consul_host = hiera('consul::server::ip'), $consul_port = hiera('consul::server::port'),) {
  $app_name = 'agiletech'
  $app_folder = "/var/www/html/${app_name}"

  $appfolder = '/root/app1/'
  $filename = '/usr/local/bin/getjarfile'
  $appfile = '/root/app1/app.jar'

  package { 'git': ensure => installed } ->
  class { 'java': package => 'java-1.8.0-openjdk-devel', } ->
  class { 'nodejs': version => 'stable', } ->
  class { 'apache': } ->
  file { $appfolder: ensure => directory, } ->
  file { $filename:
    ensure  => present,
    owner   => 'root',
    source  => 'puppet:///modules/profiles/web/getjarfile',
    require => File[$appfolder],
    mode    => '0755'
  } ->
  
  
  exec { "download-jar-file":
    command   => "${filename}",
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    logoutput => true,
 
  } ->
#  exec { "kill existing process":
#    command   => "pgrep '^java*'| xargs kill -9",
#    user      => 'root',
#    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
#    logoutput => true,
#  } ->
  exec { "provision-jar":
    command   => "java -jar ${appfile}>>/var/log/irs_app1.log 2>&1 &",
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    logoutput => true,
  # require   => Exec['download-jar-file'],
  }

  # trust all git clone
  #  exec { 'trust all git certificates':
  #    command   => "git config --global http.sslVerify false",
  #    user      => 'root',
  #    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
  #    logoutput => true,
  #    before    => Exec['remove old files and clone new ones'],
  #  }

  # get html

  #  exec { "remove old files and clone new ones":
  #    command   => "rm -rf ${app_folder} ; cd /var/www/html && git clone git@github.devgovcio.com:IRS/agiletech.git",
  #    cwd       => "/var/www/html/",
  #    user      => 'root',
  #    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
  #    logoutput => true,
  #    require   => Exec['provision-jar'],
  #  }
  #
  #   exec { "copy files to html dir ":
  #    command   => "cp -rf ${app_folder}/*  /var/www/html/ ",
  #    #cwd       => "/var/www/html/",
  #    user      => 'root',
  #    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
  #    logoutput => true,
  #    require   => Exec['remove old files and clone new ones'],
  #  }
}