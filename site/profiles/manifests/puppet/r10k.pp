class profiles::puppet::r10k {
  
  
  class { '::r10k':
    sources => {
      'modules' => {
        'remote'  => 'https://github.com/femiosinowo/puppet-site.git',
        'basedir' => "/etc/puppetlabs/code/environments/",
      }
    }
    ,
  }
  
#  class { '::r10k':
#    sources => {
#      'modules' => {
#        'remote'  => ' https://3de12c618d7c86dca80ae0c127f1821eb66b3b19@github.devgovcio.com/GovernmentCIO/puppet-site.git',
#        'basedir' => "${::settings::confdir}/environments",
#      }
#    }
#    ,
#  }
  # External webhooks often need authentication and ssl and authentication
  # Change the url below if this is changed
  # class {'r10k::webhook::config':
  #  enable_ssl => true,
  #  protected  => true,
  #  notify     => Service['webhook'],
  #}
  #
  # class {'r10k::webhook':
  #  require => Class['r10k::webhook::config'],
  #}
  #
  # # https://github.com/abrader/abrader-gms
  # # Add webhook to control repository ( the repo where the Puppetfile lives )
  # # Requires gms 0.0.6+ for disable_ssl_verify param
  # git_webhook { 'web_post_receive_webhook' :
  #  ensure             => present,
  #  webhook_url        => 'http://puppet.paosin.local:81/payload',
  #  token              =>  '1d2f7a01d97a24dc4fedd7d77d43fb486dc9150a',
  #  project_name       => 'femiosinowo/r10k',
  #  server_url         => 'https://api.github.com',
  #  disable_ssl_verify => true,
  #  provider           => 'github',
  #}
}
