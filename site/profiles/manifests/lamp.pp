class profiles::lamp (
  $lamp_password  = hiera('lamp::lamp_password'),
  $lamp_home      = hiera('lamp::lamp_home'),
  $lamp_group     = hiera('lamp::lamp_group'),
  $mysql_password = hiera('lamp::mysql_password')) {

  include apache
  include apache::mod::php
  include apache::mod::alias

  class { 'apache::mod::ssl':
    ssl_compression         => false,
    ssl_cryptodevice        => 'builtin',
    ssl_options             => ['StdEnvVars'],
    ssl_openssl_conf_cmd    => undef,
    ssl_cipher              => 'HIGH:MEDIUM:!aNULL:!MD5',
    ssl_honorcipherorder    => 'On',
    ssl_protocol            => ['all', '-SSLv2', '-SSLv3'],
    ssl_pass_phrase_dialog  => 'builtin',
    ssl_random_seed_bytes   => '512',
    ssl_sessioncachetimeout => '300',
  }

  # motd::register{ 'Apache': }
  # class apache {
  # include apache::install, apache::config, apache::service

  # motd::register{ 'Apache': }
  #}
  # include php
  # class { 'phpmyadmin': }

  class { '::mysql::server':
    root_password           => $mysql_password,
    remove_default_accounts => true,
  }

  user { 'lamp': 
    ensure   => present,
    password => $lamp_password,
    home     => $lamp_home,
  # gid		=> $lamp_group,
  }

  firewall { '101 allow 80,3306,443':
    dport  => [80,443],
    proto  => tcp,
    action => accept,
  }

  firewall { '102 allow 3306':
    dport  => 3306,
    proto  => tcp,
    action => accept,
  }
  
}
