class profiles::puppet::master {
  Exec {
    path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin', }

  #class { selinux: mode => 'permissive' }

  #pathmunge { '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin': }

  class { 'hiera':
    hierarchy => [
      "%{environment}/%{calling_class}",
      "%{environment}",
      "%{clientcert}",
      "%{fqdn}",
      "nodes/%{::clientcert}",
      "roles/%{::server_role}",
      "%{::osfamily}",
      "nodes/%{::fqdn}",
      "%{fqdn}",
      "common",
      ],
     datadir   => '/etc/puppetlabs/code/environments/production/site/hieradata',  
    #datadir   => '"${::settings::confdir}/code/environments/%{::environment}/site/hieradata"',
   
  }

#  /etc/puppetlabs/code/environments/production/
#  file { "${::settings::confdir}/code/environments/production/manifests/site.pp":
#    ensure => file,
#    source => "puppet:///modules/profiles/puppet/site.pp",
#  }

#  file { '/etc/puppet/autosign.conf':
#    ensure => file,
#    source => "puppet:///modules/profiles/puppet/autosign.conf",
#  }

#  fact { 'server_role':
#    content => 'puppet_server',
#    ensure  => present,
#  } 
 

#create_resources('infrastructure::ec2::template::create', hiera_hash('infrastructure::ec2::server')) 

  #  mcollective::plugin::client { 'filemgr': }
  #
  #  mcollective::plugin::client { 'nettest': }
  #
  #  mcollective::plugin::client { 'package': }
  #
  #  mcollective::plugin::client { 'service': }
  #
  #  mcollective::plugin::client { 'puppet': }
}