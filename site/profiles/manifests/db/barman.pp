class profiles::db::barman ($postgres_server_ip = hiera('infrastructure::ec2::postgresql::ip'),) {
  #
  # barman switch-xlog --force --archive main-db-server for new server with no WAL

  wget::fetch { "download postgresql rpm":
    source      => 'https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm',
    destination => '/tmp/',
    timeout     => 0,
    verbose     => false,
  } ->
  exec { 'rpm postgress':
    command => 'rpm -ivh /tmp/pgdg-centos96-9.6-3.noarch.rpm',
    onlyif  => "rpm -ivh /tmp/pgdg-centos96-9.6-3.noarch.rpm",
    path    => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    user    => 'root',
  # stage   => 'dns',
  # refreshonly => true,
  } ->
  # install barman
  package { 'barman': ensure => installed, } ->
  # barman conf
  file { '/etc/barman.conf':
    ensure  => file,
    # owner   => 'barman',
    # group   => 'barman',
    # mode    => 0600,
    content => template("profiles/db/barman.conf.erb"),
  } ->
  file { '/var/lib/barman/.ssh/id_rsa':
    ensure => file,
    owner  => 'barman',
    group  => 'barman',
    mode   => '0600',
    source => "puppet:///modules/profiles/db/barman_user_rsa_privatekey"
  } ->
  file { '/var/lib/barman/.ssh/id_rsa.pub':
    ensure => file,
    owner  => 'barman',
    group  => 'barman',
    mode   => '0644',
    source => "puppet:///modules/profiles/db/barman_user_rsa_key"
  } ->
  # adding progresql user to authorized keys
  file { '/var/lib/barman/.ssh/authorized_keys':
    ensure => file,
    owner  => 'barman',
    group  => 'barman',
    mode   => '0600',
    source => "puppet:///modules/profiles/db/progresql_user_rsa_key"
  }

#  file { "/etc/cron.d/barmanbackup":
#    ensure  => file,
#    owner   => 'barman',
#    group   => 'barman',
#    mode    => '0644',
#    content => inline_template("30 23 * * * /usr/bin/barman backup main-db-server\n * * * * * /usr/bin/barman cron"),
#  # content => inline_template("<%= scope.function_fqdn_rand([60]) %> * * * * root /usr/bin/puppet agent --onetime --no-daemonize
#  # --no-splay\n"),
#  }

  cron { 'barman-backup':
    command => '/usr/bin/barman backup main-db-server',
    user    => 'barman',
    hour    => 23,
    minute  => 30,
  }

  cron { 'barman-cron':
    command => '/usr/bin/barman cron',
    user    => 'barman',
    #hour    => 10,
    #minute  => 0,
  }
  #  class { 'barman':
  #    manage_package_repo => true,
  #  }
  #
  #  barman::server { 'test-server':
  #    conninfo    => 'user=postgres host=192.168.56.221',
  #    ssh_command => 'ssh postgres@192.168.56.221',
  #  }
  #
  #  file { '/var/lib/barman/.pgpass':
  #    ensure  => 'present',
  #    owner   => 'barman',
  #    group   => 'barman',
  #    mode    => 0600,
  #    content => '192.168.56.221:5432:*:postgres:insecure_password',
  #  }
}