#managed by puppet
hiera_include('classes')

node default {

}

node 'puppet.paosin.local' {
  include roles::puppetmaster 
}
 
