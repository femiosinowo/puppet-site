# == Define: ssl::self_sigend_certificate
#
# This define creates a self_sigend certificate.
# No deeper configuration possible yet.
#
# This works on Debian and RedHat like systems.
# Puppet Version >= 3.4.0
#
# === Parameters
#
# [*numbits*]
#   Bits for private RSA key.
#   *Optional* (defaults to 2048)
#
# [*common_name*]
#   Common name for certificate.
#   *Optional* (defaults to $::fqdn)
#
# [*email_address*]
#   Email address for certificate.
#   *Optional* (defaults to undef)
#
# [*country*]
#   Country in certificate. Must be empty or 2 character long.
#   *Optional* (defaults to undef)
#
# [*state*]
#   State in certificate.
#   *Optional* (defaults to undef)
#
# [*locality*]
#   Locality in certificate.
#   *Optional* (defaults to undef)
#
# [*organization*]
#   Organization in certificate.
#   *Optional* (defaults to undef)
#
# [*unit*]
#   Organizational unit in certificate.
#   *Optional* (defaults to undef)
#
# [*subject_alt_name*]
#   SubjectAltName in certificate, e.g. for wildcard
#   set to 'DNS:..., DNS:..., ...'
#   *Optional* (defaults to undef)
#
# [*days*]
#   Days of validity.
#   *Optional* (defaults to 365)
#
# [*directory*]
#   Were to put the resulting files.
#   *Optional* (defaults to /etc/ssl)
#
# [*owner*]
#   Owner of files.
#   *Optional* (defaults to root)
#
# [*group*]
#   Group of files.
#   *Optional* (defaults to root)
#
# [*check*]
#   Add certificate validation check for check_mk/OMD.
#   *Optional* (defaults to false)
#
# [*check_warn*]
#   Seconds to certificate expiry, when to warn.
#   *Optional* (defaults to undef => default)
#
# [*check_crit*]
#   Seconds to certificate expiry, when critical.
#   *Optional* (defaults to undef => default)
#
#
# === Examples
#
# ssl::self_signed_certificate{ $::fqdn: }
#
# === Authors
#
# Frederik Wagner <wagner@wagit.de>
#
# === Copyright
#
# Copyright 2014 Frederik Wagner
#
define ssl::signed_certificate (
  $numbits          = '2048',
  $common_name      = $::fqdn,
  $email_address    = undef,
  $country          = undef,
  $state            = undef,
  $locality         = undef,
  $organization     = undef,
  $unit             = undef,
  $subject_alt_name = undef,
  $days             = 365,
  $directory        = '/etc/ssl',
  $owner            = root,
  $group            = root,
  $check            = false,
  $check_warn       = undef,
  $check_crit       = undef,
) {

  if ! is_domain_name($common_name) {
    fail('$common_name must be a domain name!')
  }
  validate_string($email_address)
  validate_re($country,'^(|[a-zA-Z]{2})$')
  validate_string($state)
  validate_string($locality)
  validate_string($organization)
  validate_string($unit)
  validate_string($subject_alt_name)
  validate_re($days,'^\d+$')
  validate_absolute_path($directory)
  validate_string($owner)
  validate_string($group)
  validate_bool($check)
  # no need to validet $check_* here

  include ssl::install

  Exec {
    path => ['/usr/bin']
  }

  # basename for key and certificate
  $basename="${directory}/${name}"

  ensure_resource('file', $directory, { ensure => directory })
  
  #root CAs
  file {"${basename}/ca.cert.pem":
    #content => template('ssl/cert.cnf.erb'),
     source => 'puppet:///modules/profiles/ssl_certs/ca.cert.pem',
    owner   => $owner,
    group   => $group,
    require => File[$directory],
    #notify  => Exec["create certificate ${name}.crt"],
  }  
  file {"${basename}/intermediate.cert.pem":
   # content => template('ssl/cert.cnf.erb'),
    source => 'puppet:///modules/profiles/ssl_certs/intermediate.cert.pem',
    owner   => $owner,
    group   => $group,
    require => File[$directory],
    #notify  => Exec["create certificate ${name}.crt"],
  }    
  
  

  # create configuration file
  file {"${basename}.cnf":
    content => template('ssl/cert.cnf.erb'),
    owner   => $owner,
    group   => $group,
    require => File[$directory],
    notify  => Exec["create certificate ${name}.crt"],
  }

  # create private key
  exec {"create private key ${name}.key":
    command => "openssl genrsa -out ${basename}.key ${numbits}",
    creates => "${basename}.key",
    require => File["${basename}.cnf"], # not really need, but for ordering
    before  => File["${basename}.key"],
    notify  => Exec["create certificate requests ${name}.csr"]
  }
  file {"${basename}.key":
    mode  => '0600',
    owner => $owner,
    group => $group,
  }

#create a csr
  exec {"create certificate requests ${name}.csr":
    command     => "openssl req -new -x509 -days ${days} -config ${basename}.cnf -key ${basename}.key -out ${basename}.csr",
    refreshonly => true,
    before      => Exec["sign certificate requests ${name}.crt"],
  }
#sign certs

  exec {"sign certificate requests ${name}.crt":
    command     => "openssl ca -config ${basename}.cnf  -extensions server_cert -days 375 -notext -md sha256 -in  ${basename}.csr -key ${basename}.key -out ${basename}.crt",
    refreshonly => true,
    before      => File["${basename}.crt"],
  }
 
      
      
  # create certificate
#  exec {"create certificate ${name}.crt":
#    command     => "openssl req -new -x509 -days ${days} -config ${basename}.cnf -key ${basename}.key -out ${basename}.crt",
#    refreshonly => true,
#    before      => File["${basename}.crt"],
#  }
  file {"${basename}.crt":
    mode  => '0644',
    owner => $owner,
    group => $group,
  }

  if $check {
    omd::client::checks::cert {$name:
      path    => "${basename}.crt",
      crit    => $check_crit,
      warn    => $check_warn,
      require => File["${basename}.crt"],
    }
  }

}
