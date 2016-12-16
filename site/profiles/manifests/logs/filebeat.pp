class profiles::logs::filebeat ($elkstack_filebeat_ip_port = hiera('elkstack::filebeat::ip::port')) {
  #  class { 'topbeat':
  #    package_ensure         => absent,
  #    service_ensure => 'stopped',
  #    output         => {
  #      'logstash' => {
  #        'hosts'       => [$elkstack_filebeat_ip_port],
  #        'loadbalance' => true,
  #      }
  #      ,
  #    }
  #    ,
  #  }

  class { '::filebeat':
    outputs     => {
      'logstash' => {
        'hosts'       => [$elkstack_filebeat_ip_port],
        'loadbalance' => true,
        #        'tls'                     => {
        #          'certificate_authorities' => ["/apps/pki/cacert.pem"],
        #          'certificate'             => "/apps/pki/cert.pem",
        #          'certificate_key'         => "/apps/pki/key.pem",
        #        }
      }
      ,
    }
    ,
    prospectors => {
      'logstash' => {
        'paths'    => [
          #          '/var/log/*.log',
          '/var/log/audit/*.log',
          '/var/log/irs_app1.log',
          #          '/var/log/messages',
          #          '/var/log/secure',
          #          '/var/log/sensu/*.log',
           '/var/log/messages'
          ],
        'log_type' => 'syslog',

      }
      ,
    }
  }

  #  filebeat::prospector { 'syslogs':
  #    paths    => ['/var/log/*.log', '/var/log/syslog', '/var/log/auth.log', '/var/log/secure'],
  #    doc_type => 'syslog-beat',
  #  }


  #  file { '/etc/pki/tls/certs/logstash-forwarder.crt':
  #    ensure => file,
  #    source => "puppet:///modules/profiles/logstash/logstash-forwarder.crt",
  #  }
}

#
