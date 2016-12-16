define profiles::defines::reverse_proxy ($service_name = '', $port = '') {
  include ::haproxy

  #selinux::boolean { 'haproxy_connect_any': } # setsebool -P haproxy_connect_any 1



  haproxy::listen { 'puppet00':
    collect_exported => false,
    ipaddress        => $::ipaddress_eth1,
    ports            => '80',
  }

  haproxy::balancermember { $service_name:
    listening_service =>$service_name,
    server_names      => "${service_name}.gcio.cloud",
    ipaddresses       => $::ipaddress_eth1,
    ports             => $port,
    options           => 'check',
  }

}