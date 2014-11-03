#!/usr/bin/env puppet

$autodeploy   = false
$environments = "${::settings::confdir}/environments"
$repository   = "git://github.com/jmkeyes/puppet-configuration.git"

# Ensure we don't run this manifest on an old version of Puppet.
if versioncmp($::puppetversion, '3.6.0') < 0 {
  fail('This manifest requires Puppet version >= 3.6.0.')
}

# If r10k, hiera and inifile modules are installed, configure them.
if defined('r10k') and defined('hiera') and defined('ini_setting') {
  # Ensure r10k is installed and configured properly.
  class { '::r10k': }
  class { '::r10k::config':
    purgedirs => [ $environments ],
    sources   => {
      'base' => {
        'remote'  => $repository,
        'basedir' => $environments,
      }
    }
  }

  # Ensure Hiera is configured to use dynamic environments.
  class { '::hiera':
    datadir   => '/etc/puppet/environments/%{environment}/hiera',
    hierarchy => [
      'node/%{::clientcert}',
      'common'
    ]
  }

  ini_setting {
    # Ensure Puppet will use dynamic environments.
    'setup_puppet_environmentpath':
      ensure  => present,
      path    => "${::settings::config}",
      setting => 'environmentpath',
      value   => $environments,
      section => 'main';
    # Ensure Puppet will use global modules.
    'setup_puppet_basemodulepath':
      ensure  => present,
      value   => "${::settings::confdir}/modules",
      path    => "${::settings::config}",
      setting => 'basemodulepath',
      section => 'main';
    # Ensure Puppet doesn't use deprecated manifest option.
    'disable_manifest_option':
      ensure  => absent,
      path    => "${::settings::config}",
      setting => 'manifest',
      section => 'master';
  }

  # Ensure global Hiera config is symlinked.
  file { '/etc/hiera.yaml':
      target => "${::settings::hiera_config}",
      ensure => link
  }

  # Ensure Git is installed for r10k.
  package { 'git':
    ensure        => installed,
    allow_virtual => false
  }

  if $autodeploy {
    exec { 'deploy_r10k_environments':
      command => '/usr/local/bin/r10k deploy environment -p -v',
      require => [ Class['r10k'], Package['git'] ],
      path    => $::path
    }
  }
} else {
  notice('Installing required modules; re-apply the manifest to continue installation.')
}

exec {
  # Ensure Sharpie's r10k module is installed.
  'install_r10k_module':
    command => 'puppet module install sharpie-r10k',
    creates => "${::settings::confdir}/modules/r10k",
    path    => $::path;
  # Ensure hunner's Hiera module is installed.
  'install_hiera_module':
    command => 'puppet module install hunner-hiera',
    creates => "${::settings::confdir}/modules/hiera",
    path    => $::path;
  # Ensure PuppetLabs' inifile module is installed.
  'install_inifile_module':
    command => 'puppet module install puppetlabs-inifile',
    creates => "${::settings::confdir}/modules/inifile",
    path    => $::path
}

