#managed by puppet
hiera_include('classes')

node default {

}

node 'puppet.gcio.cloud' {
  include roles::puppetmaster 
}
