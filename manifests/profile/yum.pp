class bootstrap::profile::yum {

  # yum repos
  yumrepo { 'puppetlabs':
    baseurl             => "http://yum.puppet.com/el/${operatingsystemmajrelease}/products/${architecture}/",
    enabled             => '0',
    priority            => '99',
    gpgcheck            => '0',
    skip_if_unavailable => '1',
    descr               => 'Puppet yum repo'
  }
  package { ['yum-plugin-priorities','lynx','wget']:
    ensure => installed,
  }

  augeas { 'enable_yum_priorities':
    context => '/files/etc/yum/pluginconf.d/priorities.conf/main',
    changes => [
      "set enabled 1",
    ],
    require => [Package['yum-plugin-priorities'],Package['ruby-augeas']],
  }

}
