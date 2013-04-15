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
  }

  ssh_authorized_key { $user_name:
    user => $user_name,
    ensure => present,
    type => 'ssh-rsa',
    key => $user_authorized_key,
    require => User[$user_name],
  }

  class { 'sudo':
    username => $user_name,
  }

  class { 'ssh':
    allowusers => $ssh_allowusers,
  }
}

class gere::install {

  # configure the firewall

  class { 'iptables': }

  # install the irssi client

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
      'http://blog.totallyannette.com/feed/',
      'http://brooksreview.net/feed/',
      'http://daringfireball.net/index.xml',
      'http://drupal.org/planet/rss.xml',
      'http://drupal.org/taxonomy/term/14/0/feed',
      'http://drupal.org/taxonomy/term/30/0/feed',
      'http://feeds.arstechnica.com/arstechnica/everything',
      'http://feeds.boingboing.net/boingboing/iBag',
      'http://feeds.feedburner.com/CoudalFreshSignals',
      'http://feeds.feedburner.com/blogspot/HcFb?format=xml',
      'http://feeds.feedburner.com/codinghorror/',
      'http://feeds.penny-arcade.com/pa-mainsite',
      'http://feeds2.feedburner.com/bynkii',
      'http://givemesomethingtoread.com/rss',
      'http://ing.dk/rss/blogs/phloggen',
      'http://journalisten.dk/rss.xml',
      'http://localize.drupal.org/taxonomy/term/10/0/feed',
      'http://onethingwell.org/rss',
      'http://strobist.blogspot.com/feeds/posts/default?alt=rss',
      'http://waxy.org/links/index.xml',
      'http://www.badastronomy.com/bablog/feed/',
      'http://www.blogger.com/feeds/3157916/posts/default?alt=rss&amp;orderby=published',
      'http://www.boston.com/bigpicture/index.xml',
      'http://www.bunniestudios.com/blog/?feed=rss2',
      'http://www.davenaz.com/ashleyblue/atom.xml',
      'http://www.imore.com/feed',
      'http://www.joelonsoftware.com/rss.xml',
      'http://www.jwz.org/blog/feed/',
      'http://www.loopinsight.com/feed/',
      'http://www.macrumors.com/macrumors.xml',
      'http://www.marco.org/rss',
      'http://www.schneier.com/blog/index.rdf',
      'http://www.shorpy.com/feed',
      'http://www.wired.com/dangerroom/feed/',
      'http://www.wired.com/threatlevel/feed/',
      'http://www.xkcd.com/rss.xml',
    ],
  }

  class { 'ttytter':
    username => $user_name,
    ck => $ttytter_ck,
    cs => $ttytter_cs,
    at => $ttytter_at,
  }

  package { 'vim':
    ensure => present,
  }

  package { 'lynx':
    ensure => present,
  }

  # monitoring and notification tools

  class { 'munin::node':
    # allow => 10.0.0.0, # IP of freke
    host => 10.178.69.49,
  }

  class { 'apticron':
    recipients => $apticron_recipients,
  }

  # install various system tools

  package { 'htop':
    ensure => present,
  }

  package { 'ncdu':
    ensure => present,
  }

  package { 'ntp':
    ensure => latest,
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
      'screen -t ttytter 2 ttytter',
    ],
  }

  package { 'tmux':
    ensure => present,
  }

  # update various system settings

  class { 'timezone':
    name => 'Europe/Copenhagen',
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
