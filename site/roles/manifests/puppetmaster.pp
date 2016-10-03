class roles::puppetmaster () {
  stage { 'testing': }
  include profiles::puppet::r10k
  # include r10k::mcollective

  include profiles::puppet::master

}