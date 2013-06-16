# == Class: bash
#
# This class configures the shell.
#
# === Examples
#
#   class { 'bash': }
#
class bash() {
  file { '/etc/profile.d/aliases.sh':
    source  => 'puppet:///modules/bash/aliases.sh',
  }
}