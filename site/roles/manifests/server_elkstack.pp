class roles::server_elkstack () {
  
  include profiles::stages
  include profiles::logs::elasticsearch
  include profiles::logs::logstash
  include profiles::logs::kibana

  Class['::profiles::logs::elasticsearch'] -> Class['::profiles::logs::logstash'] -> Class['::profiles::logs::kibana']

}
