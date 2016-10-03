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

  include dnsmasq

  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
  }

  class { 'resolv_conf':
    nameservers => ['127.0.0.1', '8.8.8.8'],
    searchpath  => ['consul', 'paosin.local', $::domain]
  }

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

