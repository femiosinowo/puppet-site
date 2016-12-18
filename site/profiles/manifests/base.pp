class profiles::base () {
  include ssh
  include motd
  include stdlib
  include wget
  include epel
  # file beat for log shipping
  include profiles::logs::filebeat

  Exec {
    path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin', }

  package { 'unzip': ensure => present }

  Archive {
    provider => 'wget',
    require  => Package['wget', 'unzip'],
  }

  #  class { 'epel':
  #    stage => 'pre'
  #  }

  class { '::ruby':
    gems_version => 'latest',
    stage        => 'pre'
  }

  class { selinux:
    mode  => 'disabled',
    stage => 'pre'
  }

  class { 'yum':
    stage => 'repo'
  }

  class { '::consul':
  # stage => 'dns',
  }

  class { 'profiles::ds::ssl_certs':
    common_name      => $::fqdn,
    email_address    => 'femi@paosin.local',
    days             => 730,
    # directory        => '/etc/ssl/web',
    subject_alt_name => "DNS:*.${::domain}, DNS:${::domain}",
    stage            => 'dns',
  }

  include dnsmasq

  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
  }

  class { 'resolv_conf':
    nameservers => ['127.0.0.1', '8.8.8.8'],
    searchpath  => ['node.consul', 'paosin.local', $::domain],
    stage       => 'dns',
  }

  Class['::profiles::ds::ssl_certs'] -> Class['::resolv_conf'] # -> Class['::consul']


  #  mcollective::plugin { 'puppet': }
  #
  #  mcollective::plugin { 'service': }
  #
  #  mcollective::plugin { 'filemgr': }
  #
  #  mcollective::plugin { 'package': }

  #   firewall { '100 allow Port 80':
  #    dport  => [80, 443],
  #    proto  => tcp,
  #    action => accept,
  #  }

  # mcollective::plugin { 'apt': source => 'puppet:///modules/site_mcollective/plugins/apt', }


  create_resources('mcollective::plugin', hiera_hash('mcollective::plugins'))

  $firewall_defaults = {
    action => 'accept',
  }
  create_resources('firewall', hiera_hash('firewall::ports'), $firewall_defaults)


    file { "/root/femi":
      ensure  => directory,
    }
  
  
  #  file { "/etc/cron.d/puppet":
  #    ensure  => file,
  #    owner   => root,
  #    group   => root,
  #    mode    => 0644,
  #    content => inline_template("10 * * * * root puppet agent --onetime --no-daemonize --no-splay\n"),
  #  # content => inline_template("<%= scope.function_fqdn_rand([60]) %> * * * * root /usr/bin/puppet agent --onetime --no-daemonize
  #  # --no-splay\n"),
  #  }

  # common packages needed everywhere
  package { ['tree', 'sudo', 'screen']: ensure => present, }

  #    file { "/etc/mcollective/facts.yaml":
  #      owner    => root,
  #      group    => root,
  #      mode     => 400,
  #      loglevel => debug, # reduce noise in Puppet reports
  #      content  => inline_template("<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime_seconds|timestamp|free)/ }.to_yaml %>"),
  #    # exclude
  #    # rapidly
  #    # changing
  #    # facts
  #    }

  exec { '/apps/pki':
    command => 'mkdir -p /apps/pki',
    path    => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin',
    user    => 'root',
  # stage   => 'dns',
  # refreshonly => true,
  }

  Stage['repo'] -> Stage['dns'] -> Stage['pre'] -> Stage['main'] -> Stage['testing']
}