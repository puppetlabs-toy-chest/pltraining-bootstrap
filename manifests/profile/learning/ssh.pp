class bootstrap::profile::learning::ssh {

  augeas { "GSSAPI_enable":
    context => '/files/etc/ssh/sshd_config',
    changes => 'set GSSAPIAuthentication yes',
    require => Package['ruby-augeas'],
  }

  augeas { "disable_key_checking":
    context => '/files/etc/ssh/ssh_config',
    changes =>
      ["set Host[.='*.puppet.vm *.auroch.vm *.beauvine.vm'] '*.puppet.vm *.auroch.vm *.beauvine.vm'",
       "set Host[.='*.puppet.vm *.auroch.vm *.beauvine.vm']/StrictHostKeyChecking no",
       "set Host[.='*.puppet.vm *.auroch.vm *.beauvine.vm']/UserKnownHostsFile /dev/null"],
    require => Package['ruby-augeas'],
  }

  service { 'sshd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

}
