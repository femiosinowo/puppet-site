class roles::sensu_server () {
  include profiles::stages
  include profiles::monitor::sensu_server

}