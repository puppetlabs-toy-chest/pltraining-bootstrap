class bootstrap::profile::network {

  #Uninstall firewalld and clear all existing firewall rules
  package { 'firewalld':
    ensure => absent,
  }
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }
  exec { 'iptables -F':
    path => '/sbin',
  }

  service { 'network':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  # Remove the udev ethernet naming rules, causes problems when
  # moving VMs around. This works for rhel/centos
  file {'/etc/udev/rules.d/70-persistent-net.rules':
    ensure   => absent,
    force    => true,
  }

}
