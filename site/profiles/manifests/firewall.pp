class profiles::firewall () {
  resources { 'firewall': purge => true, }

  Firewall {
    before  => Class['my_fw::post'],
    require => Class['my_fw::pre'],
  }

  class { ['my_fw::pre', 'my_fw::post']:
  }

  #    firewall { $firewall_desc:
  #      dport  => $firewall_ports,
  #      proto  => $firewall_proto,
  #      action => $firewall_action,
  #    }
}