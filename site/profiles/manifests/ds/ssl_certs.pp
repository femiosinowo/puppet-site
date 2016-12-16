
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
class profiles::ds::ssl_certs (
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
  $directory        = '/apps/ssl',
  $owner            = root,
  $group            = root,
  $check            = false,
  $check_warn       = undef,
  $check_crit       = undef,) {
  if !is_domain_name($common_name) {
    fail('$common_name must be a domain name!')
  }

  #  validate_string($email_address)
  #  validate_re($country,'^(|[a-zA-Z]{2})$')
  #  validate_string($state)
  #  validate_string($locality)
  #  validate_string($organization)
  #  validate_string($unit)
  #  validate_string($subject_alt_name)
  #  validate_re($days,'^\d+$')
  #  validate_absolute_path($directory)
  #  validate_string($owner)
  #  validate_string($group)
  #  validate_bool($check)
  # no need to validet $check_* here

  # include ssl::install
  $ssl_folder = "/apps/ssl"
  $private_key = hiera("private_key") # "/apps/ssl/key.pem"
  $csr_server_cerets = hiera("csr_server_cerets") # "/apps/ssl/server.csr"
  $server_certs = hiera("server_certs") # "/apps/ssl/server_certs.pem"

  # root cas
  $root_ca = hiera("root_ca") # "/apps/ssl/cacerts/ca.cert.pem"
  $root_private_key = hiera("root_private_key") # "/apps/ssl/cacerts/ca.key.pem"
  $intermediate_ca = hiera("intermediate_ca") # "/apps/ssl/cacerts/intermediate.cert.pem"
  $intermediate_private_key = hiera("intermediate_private_key") # "/apps/ssl/cacerts/intermediate.key.pem"
  $ca_bundle = hiera("ca_bundle")
  #
  $index_file_attr = "/apps/ssl/cacerts/index.txt.attr"
  $index_file = "/apps/ssl/cacerts/index.txt"
  $serial_file = "/apps/ssl/cacerts/serial"

  $newcerts = "/apps/ssl/newcerts"

  $openssl_conf = "/apps/ssl/cacerts/openssl.conf"

  Exec {
    path => ['/usr/bin'] }

  # basename for key and certificate
  $basename = "${directory}"

  # create folder
  exec { $ssl_folder:
    command => "mkdir -p ${ssl_folder} ; mkdir -p ${ssl_folder}/private ; mkdir -p ${ssl_folder}/cacerts ",
    before  => File[$root_ca],
  } ~>
  exec { "create some bull shit":
    command     => "touch  ${index_file} ;  echo head -200 /dev/urandom | cksum | cut -f1 -d '' > ${serial_file} ; touch ${index_file_attr} ; mkdir -p ${newcerts}",
    before      => File[$root_ca],
    refreshonly => true,
  }

  #  ensure_resource('file', $directory, {
  #    ensure => directory
  #  }
  #  )

  # root CAs
  file { $root_ca:
    # content => template('ssl/cert.cnf.erb'),
    source  => 'puppet:///modules/profiles/ssl_certs/ca.cert.pem',
    owner   => $owner,
    group   => $group,
    require => Exec[$ssl_folder],
    before  => File[$intermediate_ca],
  }

  file { $intermediate_ca:
    source  => 'puppet:///modules/profiles/ssl_certs/intermediate.cert.pem',
    owner   => $owner,
    group   => $group,
    require => Exec[$ssl_folder],
    notify  => Exec["creat ca bundle"],
    before  => Exec['creat ca bundle'],
  }

  exec { "creat ca bundle":
    command     => "cat ${root_ca} ${intermediate_ca} > ${ca_bundle}",
    require     => File[$openssl_conf],
    refreshonly => true,
    before      => Exec['copy ca to bundle'],
    notify      => Exec["copy ca to bundle"],
  }

  exec { "copy ca to bundle":
    command     => "cat ${ca_bundle} >> /etc/pki/tls/certs/ca-bundle.crt",
    refreshonly => true,
  }

  file { $root_private_key:
    # content => template('ssl/cert.cnf.erb'),
    source  => 'puppet:///modules/profiles/ssl_certs/private/ca.key.pem',
    owner   => $owner,
    group   => $group,
    require => Exec[$ssl_folder],
  # notify  => Exec["create certificate ${name}.crt"],
  }

  file { $intermediate_private_key:
    # content => template('ssl/cert.cnf.erb'),
    source  => 'puppet:///modules/profiles/ssl_certs/private/intermediate.key.pem',
    owner   => $owner,
    group   => $group,
    require => Exec[$ssl_folder],
  # notify  => Exec["create certificate ${name}.crt"],
  }

  # create configuration file
  file { $openssl_conf:
    content => template('profiles/ssl_certs/cert.cnf.erb'),
    owner   => $owner,
    group   => $group,
    require => Exec[$ssl_folder],
    notify  => Exec["create private key"],
  }

  # create private key
  exec { "create private key":
    command     => "openssl genrsa -out ${private_key} ${numbits}",
    creates     => $private_key,
    require     => File[$openssl_conf], # not really need, but for ordering
    before      => File[$private_key],
    notify      => Exec["create certificate requests"],
    # onlyif  => "ls /apps/ssl/cacerts/"
    refreshonly => true,
  }

  file { "${private_key}":
    mode  => '0644',
    owner => $owner,
    group => $group,
  }

  # create a csr
  exec { "create certificate requests":
    command     => "openssl req  -config ${openssl_conf} -key ${private_key} -new -sha256 -out ${csr_server_cerets} -subj '/C=US/ST=Maryland/L=Baltimore/O=PaOsin Ltd/OU=IT Department/CN=${::fqdn}'",
    refreshonly => true,
    logoutput   => true,
    require     => File[$openssl_conf],
    before      => Exec["sign certificate requests"],
    notify      => Exec["sign certificate requests"],
  # require     => Exec["create private key"],
  }

  # sign certs

  exec { "sign certificate requests":
    command     => "openssl ca -batch -config ${openssl_conf} -days 375 -notext -md sha256 -in  ${csr_server_cerets} -key ${private_key} -out ${server_certs}",
    require     => File[$openssl_conf],
    refreshonly => true,
    before      => File[$server_certs],
  # onlyif  => "rm -rf /apps/ssl/cacerts/ca.cert.pem &>/dev/null"
  }

  # create certificate
  #  exec {"create certificate ${name}.crt":
  #    command     => "openssl req -new -x509 -days ${days} -config ${basename}.cnf -key ${basename}.key -out ${basename}.crt",
  #    refreshonly => true,
  #    before      => File["${basename}.crt"],
  #  }
  file { "${server_certs}":
    mode  => '0644',
    owner => $owner,
    group => $group,
  }

  #  if $check {
  #    omd::client::checks::cert {$name:
  #      path    => "${basename}.crt",
  #      crit    => $check_crit,
  #      warn    => $check_warn,
  #      require => File["${basename}.crt"],
  #    }
  #  }
}
