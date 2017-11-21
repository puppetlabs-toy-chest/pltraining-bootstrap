class bootstrap::profile::disable_mco {

  augeas { "skip mcollective tags":
    context => "/files/etc/puppetlabs/puppet/puppet.conf/main",
    changes => [
      "set skip_tags puppet_enterprise::mcollective",
    ],
  }

}
