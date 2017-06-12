# Add default memory settings after PE install

class bootstrap::profile::pe_tuning {
  file { '/etc/puppetlabs/puppet/hieradata/':
    ensure => directory
  }
  file { "/etc/puppetlabs/puppet/hieradata/${fqdn}.yaml":
    ensure => file,
    source => 'puppet:///modules/bootstrap/defaults.yaml',
  }
}

# Make sure that Hiera is configured for the master so that we
# can demo and so we can use hiera for configuration.
class classroom::master::hiera {
  assert_private('This class should not be called directly')

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  $hieradata = "/etc/puppetlabs/puppet/hieradata"

	file { "/etc/puppetlabs/puppet/hiera.yaml":
		ensure  => file,
		content => epp('bootstrap/hiera/hiera.master.yaml.epp', { 'hieradata' => $hieradata })
	}

  # we need a global hieradata directory that's outside of the control repositories
  # so that we can define sources for code manager (classroom::master::codemanager)
  file { $hieradata:
    ensure => directory,
  }

}

