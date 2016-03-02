# == Class: profile::firewall::begin

class profile::firewall::begin {
  Firewall {
    require => undef
  }

  firewall { '000 Accept all ICMP by default.':
    proto  => 'icmp',
    action => 'accept',
  } ->

  firewall { '001 Accept all on the loopback interface.':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  } ->

  firewall { '002 Accept all related and established connections.':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }
}

