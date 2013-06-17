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

  package { 'curl': }

  exec { 'download-ttytter2':
    command => 'wget -O ttytter2 http://www.floodgap.com/software/ttytter/dist2/2.1.00.txt',
    cwd     => '/usr/local/bin',
    creates => '/usr/local/bin/ttytter2',
  }

  file { '/usr/local/bin/ttytter2':
    ensure  => present,
    mode    => 0755,
    require => Exec['download-ttytter2'],
  }
}