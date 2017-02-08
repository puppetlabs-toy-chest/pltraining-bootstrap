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

  file { [ $ciab_vagrant_root, "$ciab_vagrant_root/config" ]:
    ensure => directory,
  }

  file { "$ciab_vagrant_root/Vagrantfile":
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/Vagrantfile',
  }

  file { "$ciab_vagrant_root/config/roles.yaml":
    source => 'puppet:///modules/bootstrap/classroom_in_a_box/roles.yaml',
  }

  file { "$ciab_vagrant_root/config/pe_build.yaml":
    content => epp('bootstrap/classroom_in_a_box/pe_build.yaml.epp'),
  }

  file { "$ciab_vagrant_root/config/vms.yaml":
    content => epp('bootstrap/classroom_in_a_box/vms.yaml.epp',
                   { num_students     => $::num_students,
                     num_win_students => $::num_win_students }),
  }

  $vagrant_deps = [
    File["$ciab_vagrant_root/Vagrantfile"],
    File["$ciab_vagrant_root/config/pe_build.yaml"],
    File["$ciab_vagrant_root/config/roles.yaml"],
    File["$ciab_vagrant_root/config/vms.yaml"],
    Vagrant::Box['current-puppet-master-ova'],
    Vagrant::Box['current-puppet-master-ova']
  ]

  # Start up the instructor's Vagrant box
  exec { 'start the master vagrant box':
    user        => 'training',
    path        => '/bin:/usr/bin',
    environment => [ "HOME=${training_home_path}" ],
    command     => "cd ${training_home_path}/classroom_in_a_box && vagrant up master.puppetlabs.vm",
    unless      => "cd ${training_home_path}/classroom_in_a_box && vagrant status master.puppetlabs.vm | grep ^master.puppetlabs.vm 2>/dev/null | awk '{ print $2 }' | grep ^running",
    require     => $vagrant_deps,
  }

  # Start all of the student Vagrant boxes so the port mappings are set up
  range(1, $::num_students).each |$n| {
    exec { "start the student${n}.puppetlabs.vm vagrant box":
      user        => 'training',
      path        => '/bin:/usr/bin',
      environment => [ "HOME=${training_home_path}" ],
      command     => "cd ${training_home_path}/classroom_in_a_box && vagrant up student${n}.puppetlabs.vm",
      unless      => "cd ${training_home_path}/classroom_in_a_box && vagrant up student${n}.puppetlabs.vm | grep ^student${n}.puppetlabs.vm 2>/dev/null | awk '{ print $2 }' | grep ^running",
      require     => $vagrant_deps,
    }
  }

}
