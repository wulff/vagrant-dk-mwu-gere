class iptables {
  package { 'iptables':
    ensure => latest,
  }

  file { '/etc/iptables.up.rules':
    source => 'puppet:///modules/iptables/iptables.up.rules',
    require => Package['iptables'],
    mode => 0644,
  }

  file { '/etc/network/if-pre-up.d/iptables':
    source => 'puppet:///modules/iptables/iptables',
    mode => 0755,
  }
}
