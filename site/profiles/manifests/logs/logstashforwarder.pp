class profile::logs::logstashforwarder () {
  class { 'logstashforwarder':
    servers  => ['logstash.yourdomain.com'],
    ssl_key  => 'puppet:///path/to/your/ssl.key',
    ssl_ca   => 'puppet:///path/to/your/ssl.ca',
    ssl_cert => 'puppet:///path/to/your/ssl.cert'
  }

}