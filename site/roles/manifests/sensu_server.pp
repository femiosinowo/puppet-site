class roles::sensu_server(){
  
    stage { 'testing': }
    include profiles::monitor::sensu_server
  
}