define profiles::defines::plugchecksensu (
  $pluginname  = '',
  $command     = '',
  $installed   = true,
  $subscribers = 'base',
  $handlers    = 'default',) {
    
  if ($installed) {
    package { $pluginname:
      ensure   => installed,
      provider => sensu_gem,
    }

  }

  sensu::check { $pluginname:
    command     => "/opt/sensu/embedded/bin/${command}",
    handlers    => $handlers,
    subscribers => $subscribers,
    require     => Package[$pluginname],
  }
}