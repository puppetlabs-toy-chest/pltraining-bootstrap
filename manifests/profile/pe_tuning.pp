# Add default memory settings after PE install
class bootstrap::profile::pe_tuning {
  require bootstrap::profile::pe_master

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  # we need a global hieradata directory that's outside of the control repositories
  # so that we can define sources for code manager (classroom::master::codemanager)
  $hieradata = "/etc/puppetlabs/puppet/hieradata"
  file { $hieradata:
    ensure => directory,
  }

  file { "${hieradata}/${fqdn}.yaml":
    ensure => file,
    source => 'puppet:///modules/bootstrap/defaults.yaml',
  }

  # Make sure that Hiera is configured for the master so that we
  # can demo and so we can use hiera for configuration.
  file { "/etc/puppetlabs/puppet/hiera.yaml":
    ensure  => file,
    content => epp('bootstrap/hiera/hiera.master.yaml.epp', { 'hieradata' => $hieradata })
  }
}
