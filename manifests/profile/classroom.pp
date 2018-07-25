class bootstrap::profile::classroom (
  $role          = 'master',
  $pagerduty_key = undef,
  $aws_access    = undef,
  $aws_secret    = undef,
) {
  require bootstrap::profile::rubygems

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # set up the base spec tests
  file { '/opt/pltraining/spec':
    ensure  => directory,
  }
  file { '/opt/pltraining/spec/spec_helper.rb':
    ensure => directory,
    source => 'puppet:///modules/bootstrap/serverspec/spec_helper.rb',
  }
  file { '/opt/pltraining/spec/localhost':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => "puppet:///modules/bootstrap/serverspec/${role}",
  }

  # Required net-telnet version to not require ruby >= 2.3.0
  package{'net-telnet':
    ensure   => '0.1.1',
    provider => gem,
  }

  # Required specinfra version to not require ruby >= 2.2.6
  package { 'specinfra':
    ensure   => '2.74.0',
    provider => gem,
    require  => Package['net-telnet'],
  }

  # used for updating and managing the classroom
  package { 'puppet-classroom-manager':
    ensure   => installed,
    provider => gem,
    require  => Package['specinfra'],
  }

  file { '/opt/pltraining/etc/pagerduty.key':
    ensure  => file,
    content => $pagerduty_key,
  }

  file { '/root/.aws':
    ensure  => directory,
  }
  
  file { '/root/.aws/credentials':
    ensure  => file,
    content => epp('bootstrap/aws_credentials.epp', { access => $aws_access, secret => $aws_secret } )
  }

  # make sure the vendored gem matches what the provisioner is running
  package { 'puppet':
    ensure          => $serverversion,
    provider        => gem,
    install_options => { '--bindir' => '/opt/pltraining/bin' },
  }
}
