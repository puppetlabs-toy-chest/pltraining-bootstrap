class bootstrap::role::ciab_offline {
  if str2bool($::offline) {
    # Turn off the Guacamole Docker containers so they can be
    # reprovisioned when the CIAB IP address has been changed
    # after going into hotspot mode
    service { [ 'docker-ciab-guacamole', 'docker-ciab-guacd' ]:
      ensure => stopped,
    }

    include bootstrap::profile::create_ap
  }
}
