 class profile::wordpress {
  # # Configure apache
  include apache
  include apache::mod::php
  include apache::mod::ssl

  # # Configure mysql
  include '::mysql::server'

  class { '::mysql::client': bindings_enable => true, }

  # # Configure wordpress
  class { '::wordpress':
    install_dir => '/var/www/html/paosin',
    db_name     => 'paosin',
    db_host     => 'mysql.paosin.local',
    db_password => 'P@ssw0rd',
    create_db
  }

  # class { 'wordpress': }

  class { selinux:
    mode => 'permissive'
  }

  firewall { '100 allow Port 80':
    dport  => [80, 443],
    proto  => tcp,
    action => accept,
  }

}
 