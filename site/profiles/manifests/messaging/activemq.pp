class profiles::messaging::activemq () {
  # class { 'mcollective::middleware': jetty_password => 'openssl rand -base64 20',     }


  class { 'java':
    distribution => 'jre',
    stage        => 'pre',
  } ->

  class { 'activemq':
    package_type => 'rpm',
  }

#  class { 'activemq::stomp':
#    port => 61613,
#  }
}