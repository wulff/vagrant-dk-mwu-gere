# == Class: newsbeuter
#
# This class installs the Newsbeuter feed reader.
#
# === Parameters
#
# [*version*]
#   The version of the package to install. Takes the same arguments as the
#   'ensure' parameter. Defaults to 'present'.
#
# === Examples
#
#   class { 'newsbeuter': }
#
define newsbeuter(
  $username = $title,
  $feeds = 'UNSET',
  $version  = present
) {
  package { 'newsbeuter':
    ensure => $version,
  }

  file { "/home/${username}/.newsbeuter":
    ensure => directory,
    owner => $username,
    group => $username,
  }

  file { "/home/${username}/.newsbeuter/urls":
    content => template('newsbeuter/urls.erb'),
    owner => $username,
    group => $username,
    require => File["/home/${username}/.newsbeuter"],
  }
}
