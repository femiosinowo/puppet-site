class profiles::web::dhs_app1 ($consul_host = hiera('consul::server::ip'), $consul_port = hiera('consul::server::port'),) {
  class { 'java': package => 'java-1.8.0-openjdk-devel', }

  class { 'nodejs': version => 'stable', }

  class { 'apache': }
  $appfolder = '/root/app1/'
  $filename = '/usr/local/bin/getjarfile'
  $appfile = '/root/app1/app.jar'

  file { $appfolder: ensure => directory, }

  file { $filename:
    ensure  => present,
    owner   => 'root',
    source  => 'puppet:///modules/profiles/web/getjarfile',
    require => File[$appfolder],
  }

  exec { "chmod-of-jar-file":
    command   => "chmod +x ${filename}",
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    logoutput => true,
    require   => File[$filename],
  }

  exec { "download-jar-file":
    command   => "${filename}",
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    logoutput => true,
    require   => Exec['chmod-of-jar-file'],
  }

  exec { "provision-jar":
    command   => "java -jar ${appfile}>>/var/log/dhs_app1.log 2>&1 &",
    user      => 'root',
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin',
    logoutput => true,
    require   => Exec['download-jar-file'],
  }
}