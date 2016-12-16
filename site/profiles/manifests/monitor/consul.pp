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

  $defaults = {
    acl_api_token => hiera('consul::srv_acl_token_master'),
  }
  create_resources('consul_acl', hiera_hash('consul::acl'), $defaults)

  #
  #  consul_acl { 'services':
  #    ensure        => 'present',
  #    rules         => {
  #      'service' => {
  #        '' => {
  #          'policy' => 'read'
  #        }
  #      }
  #    }
  #    ,
  #    type          => 'client',
  #    acl_api_token => 'f45cbd0b-5022-47ab-8640-4eaa7c1f40f1',
  #  }
}

