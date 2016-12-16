class profiles::logs::kibana (
  $private_key     = hiera("private_key"),
  $server_certs    = hiera("server_certs"),
  $root_ca         = hiera("root_ca"),
  $intermediate_ca = hiera("intermediate_ca"),
  $ca_bundle       = hiera("ca_bundle"),) {
  class { '::kibana4':
    service_ensure => 'running',
    service_enable => true,
    config         => {
      'elasticsearch.url'  => "http://${::fqdn}:9200",
      'ca'                 => $ca_bundle,
      'kibana_elasticsearch_username' => 'kibana4-user',
      'kibana_elasticsearch_password' => 'kibana4-password',
      'server.ssl.cert'    => $server_certs,
      'server.ssl.key'     => $private_key,
      'logging.quiet'      => true,
      'kibana_index'       => '.kibana',
      'port'               => 5601,
      'host'               => '0.0.0.0',
      'elasticsearch_preserve_host'   => true,
      'default_app_id'     => 'discover',
      'response_timeout'   => 300000,
      'shard_timeout'      => 0,
      'verify_ssl'         => false,
      'bundled_plugin_ids' => [
        'plugins/dashboard/index',
        'plugins/discover/index',
        'plugins/doc/index',
        'plugins/kibana/index',
        'plugins/markdown_vis/index',
        'plugins/metric_vis/index',
        'plugins/settings/index',
        'plugins/table_vis/index',
        'plugins/vis_types/index',
        'plugins/visualize/index'],

    }
  }

  profiles::defines::reverse_proxy { "reverse_proxy":
    service_name => 'uchiwa',
    port         => '5601'
  }
}