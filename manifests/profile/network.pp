class bootstrap::profile::network {

  #Uninstall firewalld and clear all existing firewall rules
  package { 'firewalld':
    ensure => absent,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  #Flush existing rules and save blank ruleset on centos 6
  if $::os['release']['major'] == '6' {
    exec { 'iptables -F':
      path => '/sbin',
    }
    exec { 'iptables-save > /etc/sysconfig/iptables':
      path    => '/sbin',
      require => Exec['iptables -F'],
    }
  }

  # Remove the udev ethernet naming rules, causes problems when
  # moving VMs around. This works for rhel/centos
  file {'/etc/udev/rules.d/70-persistent-net.rules':
    ensure   => absent,
    force    => true,
  }

}
