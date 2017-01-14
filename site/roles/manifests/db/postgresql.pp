class roles::db::postgresql () {
  #
  include profiles::stages

  include profiles::db::postgresql
}