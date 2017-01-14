class roles::db::barman () {
  #
  include profiles::stages

  include profiles::db::barman
}