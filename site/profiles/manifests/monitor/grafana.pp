class profiles::monitor::grafana () {
  
  class { 'grafana':
  cfg => {
    app_mode => 'production',
    server   => {
      http_port     => 8080,
    },
    database => {
      type          => 'sqlite3',
      host          => '127.0.0.1:3306',
      name          => 'grafana',
      user          => 'root',
      password      => '',
    },
    users    => {
      allow_sign_up => false,
    },
  },
}
}