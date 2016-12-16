class roles::plex_server () {
  #
  include profiles::stages

  include profiles::media::plex

}