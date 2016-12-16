class profiles::repo () {
  #
  Exec {
    path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin', }

  #
  package { 'createrepo': ensure => 'present', } ~>
  exec { 'define repo path':
    command     => 'createrepo --database /vagrant/local_repo',
    logoutput   => true,
    refreshonly => true,
  } ->
  class { 'apache':
    default_vhost => false,
  }  
  apache::vhost { 'repo.paosin.local':
    port    => '80',
    docroot => '/vagrant/local_repo',
  }

}