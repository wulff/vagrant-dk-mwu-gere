# == Class: irssi
#
# This class installs the Irssi package and a basic configuration file.
#
# === Parameters
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'irssi': }
#
class irssi(
  $realuser = 'UNSET',
  $username = 'UNSET',
  $password = 'UNSET',
  $realname = 'UNSET',
  $nick = 'UNSET',
  $version = present
) {
  package { 'irssi':
    ensure => $version,
  }

  file { "/home/${realuser}/.irssi":
    ensure => directory,
    owner => $realuser,
    group => $realuser,
    require => User[$realuser],
  }

  file { "/home/${realuser}/.irssi/config":
    content => template('irssi/config.erb'),
    require => [Package['irssi'], File["/home/${realuser}/.irssi"]],
    owner => $realuser,
    group => $realuser,
  }
}
