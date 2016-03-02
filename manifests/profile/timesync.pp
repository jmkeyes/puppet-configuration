# == Class: profile::timesync

class profile::timesync (
  $servers  = [],
) {
  class { '::ntp':
    servers => $servers,
  }
}

