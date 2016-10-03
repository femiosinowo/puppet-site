class profiles::web::app_server1 ($consul_host = hiera('consul::server::ip'), $consul_port = hiera('consul::server::port'),) {
  include selinux

  selinux::boolean { 'haproxy_connect_any':  } # setsebool -P haproxy_connect_any 1

  class { 'haproxy': config_file => '/etc/haproxy/notused' }

  # include consul_template
  class { 'consul_template':
    consul_host => $consul_host,
    consul_port => $consul_port,
  }

  consul_template::watch { 'common':
    template    => 'profiles/web/haproxy.ctmpl.erb',
    #    template_vars => {
    #      'var1' => 'foo',
    #      'var2' => 'bar',
    #    }
    #    ,
    destination => '/etc/haproxy/haproxy.cfg',
    command     => 'systemctl restart haproxy',
  }

}