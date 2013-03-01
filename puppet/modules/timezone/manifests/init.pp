# == Class: timezone
#
# This class configures the system timezone.
#
# === Parameters
#
# [*timezone*]
#   The name of the timezone, e.g. 'Europe/Copenhagen'. Required.
#
# === Examples
#
#   class { 'timezone':
#     name => 'Europe/Copenhagen',
#   }
#
class timezone(
  $name = 'UNSET'
) {
  file { '/etc/timezone':
    content => $name,
  }

  exec { 'gere-timezone-reconfigure':
    command => 'dpkg-reconfigure --frontend noninteractive tzdata',
    require => File['/etc/timezone'],
  }
}
