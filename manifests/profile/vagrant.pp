class bootstrap::profile::vagrant {
  File {
    ensure => file,
    owner  => 'training',
    group  => 'training',
    mode   => '0644',
  }

  # Ensure the external facts directory is present for when we need it
  # later
  file { '/etc/puppetlabs/facter':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  file { '/etc/puppetlabs/facter/facts.d':
    ensure => directory,
    owner  => 'root',
    group  => 'training',
    mode   => '0775',
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
  contain vagrant

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
                   { num_win_vms => $::num_win_vms }),
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

  file { "${ciab_vagrant_root}/bin/create_guacamole_ports_fact.sh":
    mode    => '0755',
    content => epp('bootstrap/classroom_in_a_box/create_guacamole_ports_fact.sh.epp',
                   { ciab_vagrant_root         => $ciab_vagrant_root,
                     guacamole_ports_fact_file => $guacamole_ports_fact_file,
                     }),
  }

  # The external fact that our script will write to
  $master_ports_fact_file = '/etc/puppetlabs/facter/facts.d/master_ports.json'

  file { "${ciab_vagrant_root}/bin/create_master_ports_fact.sh":
    mode    => '0755',
    content => epp('bootstrap/classroom_in_a_box/create_master_ports_fact.sh.epp',
                   { ciab_vagrant_root      => $ciab_vagrant_root,
                     master_ports_fact_file => $master_ports_fact_file,
                     }),
  }

  # The external fact that our script will write to
  $master_ip_fact_file = '/etc/puppetlabs/facter/facts.d/master_ip.txt'

  file { "${ciab_vagrant_root}/bin/create_master_ip_fact.sh":
    mode    => '0755',
    content => epp('bootstrap/classroom_in_a_box/create_master_ip_fact.sh.epp',
                   { ciab_vagrant_root         => $ciab_vagrant_root,
                     master_ip_fact_file       => $master_ip_fact_file,
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
    Vagrant::Box['current-puppet-master-ova']
  ]

  # Start up the instructor's Vagrant box
  exec { 'start the master vagrant box':
    user        => 'training',
    path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
    environment => [ "HOME=${training_home_path}" ],
    command     => "start_vagrant_box.sh master.puppetlabs.vm",
    unless      => "check_vagrant_box_running.sh master.puppetlabs.vm",
    timeout     => 600,
    require     => $vagrant_deps,
    before      => [ Exec['generate master IP address fact'],
                     Exec['generate master ports custom fact'] ],
  }

  range(1, $::num_win_vms).each |$n| {
    exec { "start the windows${n}.puppetlabs.vm vagrant box":
      user        => 'training',
      path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
      environment => [ "HOME=${training_home_path}" ],
      command     => "start_vagrant_box.sh windows${n}.puppetlabs.vm",
      unless      => "check_vagrant_box_running.sh windows${n}.puppetlabs.vm",
      timeout     => 600,
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
    require     => File["${ciab_vagrant_root}/bin/create_guacamole_ports_fact.sh"],
  }

  exec { 'generate master ports custom fact':
    user        => 'training',
    cwd         => $ciab_vagrant_root,
    path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
    environment => [ "HOME=${training_home_path}" ],
    command     => 'create_master_ports_fact.sh',
    creates     => $master_ports_fact_file,
    require     => File["${ciab_vagrant_root}/bin/create_master_ports_fact.sh"],
  }

  exec { 'generate master IP address fact':
    user        => 'training',
    cwd         => $ciab_vagrant_root,
    path        => "/bin:/usr/bin:${ciab_vagrant_root}/bin",
    environment => [ "HOME=${training_home_path}" ],
    command     => 'create_master_ip_fact.sh',
    creates     => $master_ip_fact_file,
  }

}
