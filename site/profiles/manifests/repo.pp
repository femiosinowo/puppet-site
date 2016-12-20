class profiles::repo (
  #
  $repo_path = hiera('repo::path'),) {
  #
  Exec {
    path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin', }

  #
  package { 'createrepo': ensure => 'present', } ~>
  exec { 'define repo path':
    command     => "createrepo --database ${repo_path}",
    logoutput   => true,
    refreshonly => true,
  } ->
  class { 'apache': default_vhost => false, }

  apache::vhost { 'repo.paosin.local':
    port    => '80',
    docroot => $repo_path,
  }

}