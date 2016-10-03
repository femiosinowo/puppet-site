class profiles::dokuwiki_server(){
$install_dir = '/var/www/html/doku'
class { 'apache':
    mpm_module => 'prefork',
}
class { 'apache::mod::php': }
apache::vhost { $::fqdn:
    docroot        => $install_dir,
    manage_docroot => false,
    port           => '80',
    override       => 'All',
}
class { 'dokuwiki':
    install_dir => $install_dir,
    wiki_title => 'GCIO DevOps - Wiki',
}

dokuwiki_user { 'femi':
    fullname     => 'Femi Osinowo',
    password     => 'P@ssw0rd',
    email        => 'fosinowo@governmentcio.com',
    groups       => 'user',
}


}