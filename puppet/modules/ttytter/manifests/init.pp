# == Class: ttytter
#
# This class installs the TTYtter Twitter client.
#
# === Parameters
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'ttytter':
#     ck => 'X',
#     cs => 'X',
#     at => '<your key>',
#   }
#
class ttytter(
  $username = 'UNSET',
  $ck       = 'UNSET',
  $cs       = 'UNSET',
  $at       = 'UNSET',
  $version  = present
) {
  package { 'ttytter':
    ensure => $version,
  }

  file { "/home/${username}/.ttytterkey":
    content => template('ttytter/ttytterkey.erb'),
    owner => $username,
    group => $username,
    require => Package['ttytter'],
  }
}