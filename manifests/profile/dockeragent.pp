class bootstrap::profile::dockeragent {
  # Run the dockeragent class to pre-install images.
  # We'll probably want to modify this at some point to use published images.

  class { 'dockeragent':
    create_no_agent_image => true,
    lvm_bashrc            => true,
    install_dev_tools     => true,
  }

}
