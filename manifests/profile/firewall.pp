# == Class: profile::firewall

class profile::firewall (
  $purge = true,
) {
  include '::stdlib::stages'

  class { '::firewall':
    stage => 'setup'
  }

  class { '::profile::firewall::begin':
    stage => 'setup',
  }

  class { '::profile::firewall::end':
    stage => 'runtime',
  }

  resources { 'firewall':
    purge => $purge,
  }
}

