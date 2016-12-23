class profiles::puppet::db {
    # Configure puppetdb and its underlying database
  class { 'puppetdb':
    listen_address => '0.0.0.0',
  }
  
}