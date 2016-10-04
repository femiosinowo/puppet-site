class roles::puppetmaster () {
  #
  include profiles::stages

  include profiles::puppet::r10k
  # include r10k::mcollective

  include profiles::puppet::master

}