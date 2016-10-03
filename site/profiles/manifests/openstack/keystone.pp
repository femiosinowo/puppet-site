class profile::openstack::keystone () {
  class { 'keystone':
    verbose             => True,
    catalog_type        => 'sql',
    admin_token         => 'random_uuid',
    database_connection => 'mysql://keystone_admin:super_secret_db_password@openstack-controller.example.com/keystone',
  }

  # Adds the admin credential to keystone.
  class { 'keystone::roles::admin':
    email    => 'admin@example.com',
    password => 'super_secret',
  }

  # Installs the service user endpoint.
  class { 'keystone::endpoint':
    public_url   => 'http://10.16.0.101:5000/v2.0',
    admin_url    => 'http://10.16.1.101:35357/v2.0',
    internal_url => 'http://10.16.2.101:5000/v2.0',
    region       => 'example-1',
  }

}