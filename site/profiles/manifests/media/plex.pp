class profiles::media::plex () {
  #  class { 'plexmediaserver':
  #    plex_user                => 'plex',
  #    plex_media_server_home   => '/plex',
  #    plex_media_server_application_support_dir => "/var/lib/plexmediaserver",
  #    plex_media_server_max_plugin_procs        => '7',
  #    plex_media_server_max_stack_size          => '20000',
  #    plex_media_server_max_lock_mem            => '4000',
  #    plex_media_server_max_open_files          => '1024',
  #    plex_media_server_tmpdir => '/var/tmp',
  #  }


  include plexmediaserver
#  file { '/home/plexthings':
#    ensure => directory,
#    owner  => 'plex',
#    group  => 'plex',
#    mode   => '0777'
#  } ->
  #  class { 'samba::server':
  #    workgroup     => 'plex',
  #    server_string => "Movies",
  #    interfaces    => "eth0 lo",
  #    security      => 'user'
  #  }
  #
  #  samba::server::share { 'PlexMovies':
  #    comment        => 'PlexMovies',
  #    path           => '/home/plexthings',
  #    # # guest_only           => true,
  #    guest_ok       => true,
  #    # guest_account        => "guest",
  #    browsable      => true,
  #    directory_mask => 0777,
  #    public         => yes,
  #    writable       => yes,
  #    write_list     => '+plex'
  #
  #  #  #    force_group          => 'group',
  #  #  #    force_user           => 'user',
  #  #  #    copy                 => 'some-other-share',
  #  }


  #  samba::server::user { 'femi':
  #    password  => 'asdf',
  #    user_name => 'femi',
  #  }
#
#  user { 'femi':
#    ensure => present,
#    groups => 'plex',
#  }

  # selinux::boolean { 'samba_export_all_ro': }

  # selinux::boolean { 'samba_export_all_rw': }

  #  firewall { '120 allow puppet stuff':
  #    dport  => [139, 445, 3005, 8324, 32469, 32400],
  #    proto  => tcp,
  #    action => accept,
  #  }
  #
  #  firewall { '121 allow puppet stuff':
  #    dport  => [137, 138, 1900, 5353, 32410],
  #    proto  => udp,
  #    action => accept,
  #  }
}