class bootstrap::profile::network {

  # Clear all existing firewall rules
  resources { 'firewall':
    purge => true,
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
