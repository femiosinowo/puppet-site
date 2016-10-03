class profiles::monitor::sensu_plugins () {
  #  Exec {
  #    path => '/usr/bin:/opt/sensu/embedded/bin/', }

  # pathmunge { '/opt/sensu/embedded/bin/': } 
  sudoers::allowed_command { "metrics-puppet-run":
    command          => "/opt/sensu/embedded/bin/metrics-puppet-run.rb -p /var/lib/puppet/state/last_run_summary.yaml",
    user             => "sensu",
    require_password => false,
    comment          => "Allows access to the file "
  }

  sudoers::allowed_command { "checkpuppet-last_run":
    command          => "/opt/sensu/embedded/bin/checkpuppet-last-run.rb -s /var/lib/puppet/state/last_run_summary.yaml",
    user             => "sensu",
    require_password => false,
    comment          => "Allows access to the file "
  }

  sensu::handler { 'default': command => 'mail -s \'sensu alert\' fosinowo@governmentcio.com', }

  #package { 'gcc-c++': ensure => installed, }  
  package { 'sensu-plugins-consul':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-rabbitmq':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-uchiwa':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-haproxy':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-redis':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-puppet':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-docker':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-elasticsearch':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  package { 'sensu-plugins-logstash':
    ensure   => installed,
    provider => sensu_gem,
  } ->
  profiles::defines::plugchecksensu { 'cpu-checks':
    pluginname => 'sensu-plugins-cpu-checks',
    command    => 'check-cpu.rb'
  }

  profiles::defines::plugchecksensu { 'selinux':
    pluginname => 'sensu-plugins-selinux',
    command    => 'check-selinux.rb'
  }

  #  profiles::defines::plugchecksensu { 'ntp':
  #    pluginname => 'sensu-plugins-ntp',
  #    command    => 'check-ntp.rb'
  #  }

  profiles::defines::plugchecksensu { 'disk-check':
    pluginname => 'sensu-plugins-disk-checks',
    command    => 'check-disk-usage.rb -w 80 -c 90'
  }

  #  sensu::check { 'check_memory':
  #    command     => 'check-memory-percent.rb',
  #    handlers    => 'default',
  #    subscribers => 'base',
  #    require     => Package['sensu-plugins-memory-checks'],
  #  }

  #  profiles::defines::plugchecksensu { 'memory':
  #    pluginname => 'sensu-plugins-memory-checks',
  #    command    => 'check-memory-percent.rb'
  #  }
  #  profiles::defines::plugchecksensu { 'logstash':
  #    pluginname => 'sensu-plugins-logstash',
  #    command    => 'handler-logstash'
  #  }
  #  profile::plugchecksensu { 'logstash':
  #    pluginname => 'sensu-plugins-logstash',
  #    command    => 'handler-logstash'
  #  }

  #  profile::plugchecksensu { 'fs-check':
  #    pluginname => ' sensu-plugins-filesystem-checks',
  #    command    => 'check-dir-count.rb'
  #  }

  #  sensu::check { 'check_disk':
  #    command     => 'check-disk-usage.rb -w 80 -c 90',
  #    handlers    => 'default',
  #    subscribers => 'base',
  #    require     => Package['sensu-plugins-cpu-checks'],
  #  }
  #
  #  sensu::check { 'check_memory':
  #    command     => 'check-memory-percent.rb',
  #    handlers    => 'default',
  #    subscribers => 'base',
  #    require     => Package['sensu-plugins-memory-checks'],
  #  }
  #  package { 'centos-release-SCL':
  #    ensure   => latest,
  #    provider => yum,
  #  }
  #
  #  package { 'ruby193':
  #    ensure   => latest,
  #    provider => yum,
  #    require  => Package['centos-release-SCL']
  #  }
  #
  #  # profiled::script { 'ruby193.sh': content => 'source /opt/rh/ruby193/enable' }
  #
  #  file { '/opt/sensu-plugins': ensure => directory, }
}
