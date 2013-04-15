Vagrant: Gere
=============

TODO: screen should be class for installing package, define for adding settings.

Makes it possible to set up a local copy of gere.mwu.dk.

    apt-get update
    apt-get install puppet
    puppet apply --modulepath=puppet/modules/ puppet/manifests/site.pp
    dpkg-reconfigure postfix

The current version of the manifest installs the following useful applications:

* apticron
* htop
* irssi
* lynx
* ncdu
* newsbeuter
* screen
* tmux
* ttytter
* vim

Settings
--------

To use the included manifests, you need to add a `settings.pp` file to the `puppet/manifests` directory. It should define the following variables:

    $user_name = 'johndoe'
    $user_comment = 'John Doe'
    $user_authorized_key = '<id_rsa.pub>'

    $ssh_allowusers = 'johndoe vagrant'

    $irssi_real_name = 'John Doe'
    $irssi_user_name = 'johndoe'
    $irssi_user_pass = 'secret'
    $irssi_user_nick = 'jdoe'

    $apticron_recipients = 'jdoe@example.com'

    $ttytter_ck = 'X'
    $ttytter_cs = 'X'
    $ttytter_at = '<token>'
