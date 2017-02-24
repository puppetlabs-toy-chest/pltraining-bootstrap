class bootstrap::profile::vagrant {
  File {
    ensure => file,
    owner  => 'training',
    group  => 'training',
    mode   => '0644',
  }

  # Ensure the external facts directory is present for when we need it
  # later
  file { [ '/etc/puppetlabs/facter', '/etc/puppetlabs/facter/facts.d' ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  # vagrant will run as the "training" user from this home directory
  $training_home_path = '/home/training'

  # Contain this class because the containing class has an ordering
  # dependency applied to it
  contain virtualbox

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

  file { "${ciab_vagrant_root}/bin/check_vagrant_box_running.sh":
    mode    => '0755',
    content => epp('bootstrap/classroom_in_a_box/check_vagrant_box_running.sh.epp',
                   { training_home_path => $training_home_path }),
  }

  # The external fact that our script will write to
  $guacamole_ports_fact_file = '/etc/puppetlabs/facter/facts.d/guacamole_ports.json'

  # Ensure proper ownership on the external fact output file. The
  # fact generation script has to run as the training user in order to
  # retrieve information from vagrant.
  file { $guacamole_ports_fact_file:
    owner => 'training',
    group => 'training',
  }

  file { "${ciab_vagrant_root}/bin/create_guacamole_ports_fact.sh":
    mode    => '0755',
    content => epp('bootstrap/classroom_in_a_box/create_guacamole_ports_fact.sh.epp',
                   { ciab_vagrant_root         => $ciab_vagrant_root,
                     guacamole_ports_fact_file => $guacamole_ports_fact_file,
                     }),
  }

  # All of these resources need to be enforced before we start
  # bringing up vagrant boxes
  $vagrant_deps = [
    File["${ciab_vagrant_root}/Vagrantfile"],
    File["${ciab_vagrant_root}/config/pe_build.yaml"],
    File["${ciab_vagrant_root}/config/roles.yaml"],
    File["${ciab_vagrant_root}/config/vms.yaml"],
    File["${ciab_vagrant_root}/bin/start_vagrant_box.sh"],
    File["${ciab_vagrant_root}/bin/check_vagrant_box_running.sh"],
    Vagrant::Box['current-puppet-master-ova'],
    Vagrant::Box['current-puppet-master-ova']
  ]

  # Start up the instructor's Vagrant box
  exec { 'start the master vagrant box':
    user        => 'training',
    path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
    environment => [ "HOME=${training_home_path}" ],
    command     => "start_vagrant_box.sh master.puppetlabs.vm",
    unless      => "check_vagrant_box_running.sh master.puppetlabs.vm",
    require     => $vagrant_deps,
  }

  # Start all of the student Vagrant boxes so the port mappings are set up
  range(1, $::num_students - $::num_win_students).each |$n| {
    exec { "start the linux${n}.puppetlabs.vm vagrant box":
      user        => 'training',
      path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
      environment => [ "HOME=${training_home_path}" ],
      command     => "start_vagrant_box.sh linux${n}.puppetlabs.vm",
      unless      => "check_vagrant_box_running.sh linux${n}.puppetlabs.vm",
      require     => $vagrant_deps,
      before      => Exec['generate guacamole ports custom fact'],
    }
  }

  range($::num_students - $::num_win_students + 1, $::num_students).each |$n| {
    exec { "start the windows${n}.puppetlabs.vm vagrant box":
      user        => 'training',
      path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
      environment => [ "HOME=${training_home_path}" ],
      command     => "start_vagrant_box.sh windows${n}.puppetlabs.vm",
      unless      => "check_vagrant_box_running.sh windows${n}.puppetlabs.vm",
      require     => $vagrant_deps,
      before      => Exec['generate guacamole ports custom fact'],
    }
  }

  exec { 'generate guacamole ports custom fact':
    user        => 'training',
    cwd         => $ciab_vagrant_root,
    path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
    environment => [ "HOME=${training_home_path}" ],
    command     => 'create_guacamole_ports_fact.sh',
    creates     => $guacamole_ports_fact_file,
  }

}
