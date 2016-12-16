class profiles::logs::elasticsearch (
  $unicast_hosts   = [],
  $private_key     = hiera("private_key"),
  $server_certs    = hiera("server_certs"),
  $root_ca         = hiera("root_ca"),
  $intermediate_ca = hiera("intermediate_ca"),
  $ca_bundle       = hiera("ca_bundle"),) {
  Archive {
    provider => 'wget',
    require  => Package['wget', 'unzip'],
  }

  class { '::elasticsearch':
    java_install => true,
    ensure       => 'present',
    manage_repo  => true,
    repo_version => '2.x',
  # package_url  =>
  # 'https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.3.4/elasticsearch-2.3.4.rpm',
  # autoupgrade  => true,
  }

  elasticsearch::instance { 'es-01':
    ssl    => false,
    # ca_certificate    => $ca_bundle,
    # certificate       => $server_certs,
    # private_key       => $private_key,
    # keystore_password => 'changeit',
    config => {
      'network.host'           => "${::fqdn}",
      'discovery.zen'          => {
        'ping.unicast.hosts'     => ["localhost.localdomain"],
        'minimum_master_nodes'   => 1,
        'ping.multicast.enabled' => false,
        #'shield.ssl.ciphers'     => '[ "TLS_RSA_WITH_AES_128_CBC_SHA256", "TLS_RSA_WITH_AES_128_CBC_SHA" ]',
      }
      ,

    }
  }

  Elasticsearch::Plugin {
    instances => ['es-01'], }

  elasticsearch::plugin { 'mobz/elasticsearch-head': }

#  elasticsearch::plugin { 'elasticsearch/license/latest': }
#
#  elasticsearch::plugin { 'elasticsearch/shield/latest': }
#
#  elasticsearch::shield::user { 'kibana4-user':
#    password => 'kibana4-password',
#    roles    => ['kibana4_server'],
#  }
}

