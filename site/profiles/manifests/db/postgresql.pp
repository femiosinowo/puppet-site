class profiles::db::postgresql (
  #http://pgfoundry.org/frs/download.php/527/world-1.0.tar.gz
  $barman_server_ip = hiera('infrastructure::ec2::barman::ip'),

  #
  ) {
  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.6',
  } ->
  class { 'postgresql::server':
    listen_addresses     => '*',
    postgres_password    => 'insecure_password',
    pg_hba_conf_defaults => false,
  }

  # vim /var/lib/pgsql/9.6/data/pg_hba.conf
  postgresql::server::pg_hba_rule { 'Local access':
    type        => 'local',
    database    => 'all',
    user        => 'all',
    auth_method => 'peer',
  }

  postgresql::server::pg_hba_rule { 'Barman access':
    type        => 'host',
    database    => 'all',
    user        => 'all',
    address     => "${barman_server_ip}/32",
    auth_method => 'trust',
  }

  postgresql::server::config_entry {
    'wal_level':
      value => 'archive';

    'archive_mode':
      value => 'on';

    'archive_command':
      value => "rsync -a %p barman@${barman_server_ip}:/var/lib/barman/main-db-server/incoming/%f";
  }

  class { 'postgresql::server::contrib':
    package_ensure => 'present',
  }

  postgresql::server::db { 'mydatabasename':
    user     => 'mydatabaseuser',
    password => postgresql_password('mydatabaseuser', 'mypassword'),
  }

  postgresql::server::role { 'marmot': password_hash => postgresql_password('marmot', 'mypasswd'), }

  postgresql::server::database_grant { 'test1':
    privilege => 'ALL',
    db        => 'mydatabasename',
    role      => 'marmot',
  }

  #contain postgresql::server

  file { '/var/lib/pgsql/.ssh/id_rsa':
    ensure  => file,
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0600',
    source  => "puppet:///modules/profiles/db/progresql_user_rsa_privatekey",
    require => Class['::postgresql::server'],
  } ->
  file { '/var/lib/pgsql/.ssh/id_rsa.pub':
    ensure => file,
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0644',
    source => "puppet:///modules/profiles/db/progresql_user_rsa_key"
  } ->
  # adding barman user key to authorized keys
  file { '/var/lib/pgsql/.ssh/authorized_keys':
    ensure => file,
    owner  => 'postgres',
    group  => 'postgres',
    mode   => '0600',
    source => "puppet:///modules/profiles/db/barman_user_rsa_key"
  }
  #  postgresql::server::table_grant { 'my_table of test2':
  #    privilege => 'ALL',
  #    table     => 'my_table',
  #    db        => 'mydatabasename',
  #    role      => 'marmot',
  #  }


  # Class['::postgresql::server'] -> File['/var/lib/pgsql/.ssh/id_rsa']
  # Class['::postgresql::server'] -> Class['::profiles::db::barman']
  #  class { 'postgresql::server':
  #    listen_addresses     => '*',
  #    postgres_password    => 'insecure_password',
  #    pg_hba_conf_defaults => false,
  #  }
  #
  #  postgresql::server::pg_hba_rule { 'Local access':
  #    type        => 'local',
  #    database    => 'all',
  #    user        => 'all',
  #    auth_method => 'peer',
  #  }
  #
  #  postgresql::server::pg_hba_rule { 'Barman access':
  #    type        => 'host',
  #    database    => 'all',
  #    user        => 'postgres',
  #    address     => '127.0.0.1',
  #    auth_method => 'md5',
  #  }
  #
  #  postgresql::server::config_entry {
  #    'wal_level':
  #      value => 'archive';
  #
  #    'archive_mode':
  #      value => 'on';
  #
  #    'archive_command':
  #      value => 'rsync -a %p barman@192.168.56.222:/var/lib/barman/test-server/incoming/%f';
  #  }
  #
  #  class { 'postgresql::server::contrib':
  #    package_ensure => 'present',
  #  }
}