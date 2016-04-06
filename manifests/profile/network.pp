class bootstrap::profile::network {

  # Make sure the firewall isn't running
  service { 'iptables':
    enable => false,
    ensure => stopped,
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
