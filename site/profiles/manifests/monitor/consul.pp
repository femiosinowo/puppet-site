class profiles::monitor::consul () {
  # include ::haproxy

  #  profiles::defines::reverse_proxy { "reverse_proxy":
  #    service_name => 'consul',
  #    port         => '8500',
  #   require      => Package['haproxy']
  #  }
  #  dnsmasq::dnsserver { 'forward-zone-consul':
  #    domain => 'consul',
  #    ip     => '127.0.0.1',
  #    port   => '8600',
  #    notify => Service['dnsmaq'],
  #  }



  #  $aliases = ['consul', $::fqdn]
  #
  #  # Reverse proxy for Web interface
  #  include 'nginx'
  #
  #  $server_names = [$::fqdn, $aliases]
  #
  #  nginx::resource::vhost { $::fqdn:
  #    proxy       => 'http://localhost:8500',
  #    server_name => $server_names,
  #  }
}

