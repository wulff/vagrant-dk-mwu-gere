# basic site manifest

# define global paths and file ownership
Exec { path => '/usr/sbin/:/sbin:/usr/bin:/bin' }
File { owner => 'root', group => 'root' }

# create a stage to make sure apt-get update is run before all other tasks
stage { 'requirements': before => Stage['main'] }
stage { 'bootstrap': before => Stage['requirements'] }

import 'settings'

class gere::bootstrap {
  # we need an updated list of sources before we can apply the configuration
  exec { 'gere_apt_update':
    command => '/usr/bin/apt-get update',
  }
}

class gere::requirements {
  # install git-core and add some useful aliases
  class { 'git': }

  user { $user_name:
    ensure => present,
    managehome => true,
    comment => $user_comment,
    shell => '/bin/bash',
    groups => ['sudo'],
    password => $user_password,
  }

  ssh_authorized_key { $user_name:
    user => $user_name,
    ensure => present,
    type => 'ssh-rsa',
    key => $user_authorized_key,
    require => User[$user_name],
  }

  class { 'ssh':
    allowusers => $ssh_allowusers,
  }
}

class gere::install {

  # configure the firewall

  class { 'iptables': }

  # configure postfix as a null client
  # http://www.postfix.org/STANDARD_CONFIGURATION_README.html#null_client

  class { 'postfix':
    hostname => 'gere.mwu.dk',
  }

  # install network clients and tools

  class { 'irssi':
    realuser => $user_name,
    username => $irssi_user_name,
    password => $irssi_user_pass,
    nick => $irssi_user_nick,
    realname => $irssi_real_name,
  }

  newsbeuter { $user_name:
    feeds => [
      'http://ascii.textfiles.com/feed/atom',
      'http://brooksreview.net/feed/',
      'http://daringfireball.net/index.xml',
      'http://feeds.feedburner.com/CoudalFreshSignals',
      'http://feeds.feedburner.com/blogspot/HcFb?format=xml',
      'http://feeds.feedburner.com/codinghorror/',
      'http://feeds2.feedburner.com/bynkii',
      'http://givemesomethingtoread.com/rss',
      'http://ing.dk/rss/blogs/phloggen',
      'http://journalisten.dk/rss.xml',
      'http://onethingwell.org/rss',
      'http://waxy.org/links/index.xml',
      'http://www.boston.com/bigpicture/index.xml',
      'http://www.bunniestudios.com/blog/?feed=rss2',
      'http://www.imore.com/feed',
      'http://www.jwz.org/blog/feed/',
      'http://www.loopinsight.com/feed/',
      'http://www.macrumors.com/macrumors.xml',
      'http://www.marco.org/rss',
      'http://www.schneier.com/blog/index.rdf',
    ],
  }

  package { 'lynx':
    ensure => present,
  }

  package { 'elinks':
    ensure => present,
  }

  package { 'nmap':
    ensure => present,
  }

  package { 'iftop':
    ensure => present,
  }

  package { 'siege':
    ensure => present,
  }

  package { 'surfraw':
    ensure => present,
  }

  package { 'ngrep':
    ensure => present,
  }

  package { 'rtorrent':
    ensure => present,
  }

  package { 'alpine':
    ensure => present,
  }

  package { 'mcabber':
    ensure => present,
  }

  # install and configure editors and productivity tools

  package { 'vim':
    ensure => present,
  }
  exec { 'set-default-editor':
    command => 'update-alternatives --set editor /usr/bin/vim.basic',
    require => Package['vim'],
  }

  package { 'emacs24-nox':
    ensure => present,
  }

  package { 'task':
    ensure => present,
  }

  package { 'qalc':
    ensure => present,
  }

  package { 'ledger':
    ensure => present,
  }

  package { 'calcurse':
    ensure => present,
  }

  # install graphics and a/v tools

  package { 'libav-tools':
    ensure => present,
  }

  package { 'imagemagick':
    ensure => present,
  }

  package { 'graphviz':
    ensure => present,
  }

  package { 'gnuplot-nox':
    ensure => present,
  }

  package { 'youtube-dl':
    ensure => present,
  }

  package { 'mimms':
    ensure => present,
  }

  # install gis tools

  package { 'gdal-bin':
    ensure => present,
  }

  package { 'mapnik-utils':
    ensure => present,
  }

  package { 'libmapnik-dev':
    ensure => present,
  }

  package { 'node-carto':
    ensure => present,
  }

  package { 'node-millstone':
    ensure => present,
  }

  # install development tools

  package { 'jq':
    ensure => present,
  }

  package { 'cloc':
    ensure => present,
  }

  # install various toys

  package { 'figlet':
    ensure => present,
  }

  package { 'tig':
    ensure => present,
  }

  package { 'cowsay':
    ensure => present,
  }

  package { 'fortune-mod':
    ensure => present,
  }
  package { 'fortunes-min':
    ensure => present,
  }
  package { 'fortunes-bofh-excuses':
    ensure => present,
  }

  package { 'nethack-console':
    ensure => present,
  }

  # monitoring and notification tools

  class { 'munin::node':
    host => '192.168.187.17',
    allow => '^192\.168\.157\.235$',
  }

  class { 'apticron':
    recipients => $apticron_recipients,
  }

  # install various system tools

  package { 'htop':
    ensure => present,
  }

  package { 'atop':
    ensure => present,
  }

  package { 'ncdu':
    ensure => present,
  }

  package { 'ntp':
    ensure => latest,
  }

  package { 'pv':
    ensure => present,
  }

  package { 'dstat':
    ensure => present,
  }

  package { 'atsar':
    ensure => present,
  }

  package { 'multitail':
    ensure => present,
  }

  package { 'ack-grep':
    ensure => present,
  }

  package { 'tree':
    ensure => present,
  }

  screen { $user_name:
    options => {
      'vbell' => 'on',
      'autodetach' => 'on',
      'startup_message' => 'off',
    },
    additions => [
      'screen -t local 0',
      'screen -t irssi 1 irssi',
      'screen -t newsbeuter 2 newsbeuter',
      'shelltitle \'\'',
      'caption always "%{= KW}%-Lw%{= wb}%n %t %{= KW}%+Lw %-=| ${USER}@%H | %M%d %c%{-}"',
    ],
  }

  # update various system settings

  class { 'timezone':
    name => 'Europe/Copenhagen',
  }

  file { '/etc/profile.d/aliases.sh':
    content => 'alias update="sudo apt-get update"
alias upgrade="sudo apt-get upgrade"
alias puppet-apply="sudo puppet apply --modulepath=/home/wulff/vagrant/puppet/modules/ /home/wulff/vagrant/puppet/manifests/site.pp"',
    mode => 0644,
  }
  file { "/home/${username}/.bash_aliases":
    content => 'alias update="sudo apt-get update"
alias upgrade="sudo apt-get upgrade"
alias puppet-apply="sudo puppet apply --modulepath=/home/wulff/vagrant/puppet/modules/ /home/wulff/vagrant/puppet/manifests/site.pp"',
    mode => 0644,
  }

  file { '/etc/hostname':
    content => 'gere.mwu.dk',
    mode => 0644,
  }
  exec { 'update-hostname':
    command => '/bin/hostname -F /etc/hostname',
    require => File['/etc/hostname'],
  }
}

class gere::go {
  class { 'gere::bootstrap':
    stage => 'bootstrap',
  }
  class { 'apt':
    stage => 'requirements',
  }
  class { 'gere::requirements':
    stage => 'requirements',
  }
  class { 'gere::install': }
}

include gere::go
