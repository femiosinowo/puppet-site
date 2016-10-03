class profiles::serverspec () {
  package { 'rspec-puppet': provider => gem, }

  package { 'rspec_junit_formatter': provider => gem, }

  package { 'serverspec': provider => gem, }

  package { 'rake': provider => gem, }

  file { '/usr/local/serverspec': ensure => directory, } ->
  file { '/usr/local/serverspec/spec': ensure => directory, } ->
  file { '/usr/local/serverspec/run_test.sh':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/scripts/run_test.sh",
    mode   => '0777',
  } ->
  file { '/usr/local/serverspec/send_report.sh':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/scripts/send_report.sh",
    mode   => '0777',
  } ->
  file { '/usr/local/serverspec/send_indicator.sh':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/scripts/send_indicator.sh",
    mode   => '0777',
  } ->
  file { '/usr/local/serverspec/terraform_serverspec.sh':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/scripts/terraform_serverspec.sh",
    mode   => '0777',
  } ->
  file { '/usr/local/serverspec/Rakefile':
    ensure  => file,
    # source => "puppet:///modules/${module_name}/common/tests/serverspec/Rakefile",
    content => template("${module_name}/common/tests/Rakefile.erb"),
  } ->
  file { '/root/.rspec':
    ensure  => file,
    # source => "puppet:///modules/${module_name}/common/tests/serverspec/.rspec",
    content => template("${module_name}/common/tests/.rspec.erb"),
  } ->
  file { '/usr/local/serverspec/.rspec':
    ensure  => file,
    # source => "puppet:///modules/${module_name}/common/tests/serverspec/.rspec",
    content => template("${module_name}/common/tests/.rspec.erb"),
  } ->
  # file { "/usr/local/serverspec/${::puppet_role}":
  file { "/usr/local/serverspec/${::server_role}": ensure => directory, } ->
  file { '/usr/local/serverspec/spec/spec_helper.rb':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/serverspec/spec_helper.rb",
  } ->
  file { '/usr/local/serverspec/properties.yml':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/serverspec/properties/packer/${::server_role}_properties.yml",
  } ->
  file { '/tmp/properties.yml':
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/serverspec/properties/terraform/${::server_role}_properties.yml",
  } ->
  file { "/usr/local/serverspec/${::server_role}/config_spec.rb":
    ensure => file,
    source => "puppet:///modules/${module_name}/common/tests/serverspec/classes/config_spec.rb",
  } ->
  exec { 'run serverspec test':
    command   => 'sh run_test.sh',
    cwd       => '/usr/local/serverspec',
    logoutput => true,
    path      => '/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin',
  }

}