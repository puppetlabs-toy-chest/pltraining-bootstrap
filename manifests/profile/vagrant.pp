class bootstrap::profile::vagrant {
  File {
    ensure => file,
    owner  => 'training',
    group  => 'training',
    mode   => '0644',
  }

  $training_home_path = '/home/training'

  include virtualbox

  # Note that the latest version of Vagrant at this time (1.9.1) does not
  # seem to work correctly with the auto-network plugin, and the master
  # Vagrant box does not receive an IP address successfully. Stick with
  # 1.8.7 for now.
  class { 'vagrant':
    version => '1.8.7',
    require => Class['virtualbox'],
  }

  $vagrant_plugins = [
    'oscar', 'vagrant-hosts', 'vagrant-auto_network', 'vagrant-pe_build',
    'vagrant-vbox-snapshot', 'vagrant-reload'
  ]

  vagrant::plugin { $vagrant_plugins:
    user    => 'training',
    require => Class['vagrant'],
  }

  # Convert the latest Puppet master instructor OVA and install as a
  # Vagrant box
  vagrant::box { 'current-puppet-master-ova':
    user    => 'training',
    source  => 'http://downloads.puppetlabs.com/training/puppet-master.ova',
    require => Class['vagrant'],
  }

  # Convert the latest Puppet master instructor OVA and install as a
  # Vagrant box
  vagrant::box { 'current-puppet-student-ova':
    user    => 'training',
    source  => 'http://downloads.puppetlabs.com/training/puppet-student.ova',
    require => Class['vagrant'],
  }

  # Configure the Oscar environment with the proper files to provision
  # a master Vagrant box and the required number of student Vagrant boxes
  $ciab_vagrant_root = "${training_home_path}/classroom_in_a_box"

  file { [ $ciab_vagrant_root, "${ciab_vagrant_root}/config",
           "${ciab_vagrant_root}/bin" ]:
    ensure => directory,
  }

  file { "${ciab_vagrant_root}/Vagrantfile":
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/Vagrantfile',
  }

  file { "${ciab_vagrant_root}/config/roles.yaml":
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/roles.yaml',
  }

  file { "${ciab_vagrant_root}/config/pe_build.yaml":
    content => epp('bootstrap/classroom_in_a_box/pe_build.yaml.epp'),
  }

  file { "${ciab_vagrant_root}/config/vms.yaml":
    content => epp('bootstrap/classroom_in_a_box/vms.yaml.epp',
                   { num_students     => $::num_students,
                     num_win_students => $::num_win_students }),
  }

  file { "${ciab_vagrant_root}/bin/start_vagrant_box.sh":
    mode    => '0755',
    content => epp('bootstrap/classroom_in_a_box/start_vagrant_box.sh.epp',
                   { training_home_path => $training_home_path }),
  }

  # All of these resources need to be enforced before we start
  # bringing up vagrant boxes
  $vagrant_deps = [
    File["${ciab_vagrant_root}/Vagrantfile"],
    File["${ciab_vagrant_root}/config/pe_build.yaml"],
    File["${ciab_vagrant_root}/config/roles.yaml"],
    File["${ciab_vagrant_root}/config/vms.yaml"],
    File["${ciab_vagrant_root}/bin/start_vagrant_box.sh"],
    Vagrant::Box['current-puppet-master-ova'],
    Vagrant::Box['current-puppet-master-ova']
  ]

  # Start up the instructor's Vagrant box
  exec { 'start the master vagrant box':
    user        => 'training',
    path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
    environment => [ "HOME=${training_home_path}" ],
    command     => "start_vagrant_box.sh master.puppetlabs.vm",
    unless      => "cd ${training_home_path}/classroom_in_a_box && vagrant status master.puppetlabs.vm | grep ^master.puppetlabs.vm 2>/dev/null | awk '{ print $2 }' | grep -q ^running",
    require     => $vagrant_deps,
    logoutput   => true,
  }

  # Set up the structured fact that will store the Vagrant box port
  # forwards for guacamole configuration
  file { [ '/etc/puppetlabs/facter', '/etc/puppetlabs/facter/facts.d' ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  $guacamole_ports_fact = '/etc/puppetlabs/facter/facts.d/guacamole_ports.json'

  # concat { $guacamole_ports_fact:
  #   owner => 'root',
  #   group => 'root',
  # }

  # Start all of the student Vagrant boxes so the port mappings are set up
  range(1, $::num_students - $::num_win_students).each |$n| {
    exec { "start the linux${n}.puppetlabs.vm vagrant box":
      user        => 'training',
      path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
      environment => [ "HOME=${training_home_path}" ],
      command     => "start_vagrant_box.sh linux${n}.puppetlabs.vm",
      unless      => "cd ${training_home_path}/classroom_in_a_box && vagrant status linux${n}.puppetlabs.vm | grep ^linux${n}.puppetlabs.vm 2>/dev/null | awk '{ print $2 }' | grep -q ^running",
      require     => $vagrant_deps,
      logoutput   => true,
    }
  }

  range($::num_students - $::num_win_students + 1, $::num_students).each |$n| {
    exec { "start the windows${n}.puppetlabs.vm vagrant box":
      user        => 'training',
      path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
      environment => [ "HOME=${training_home_path}" ],
      command     => "start_vagrant_box.sh windows${n}.puppetlabs.vm",
      unless      => "cd ${training_home_path}/classroom_in_a_box && vagrant status windows${n}.puppetlabs.vm | grep ^windows${n}.puppetlabs.vm 2>/dev/null | awk '{ print $2 }' | grep -q ^running",
      require     => $vagrant_deps,
      logoutput   => true,
    }
  }

}
