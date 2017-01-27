class bootstrap::profile::vagrant {
  File {
    ensure => file,
    owner  => 'training',
    group  => 'training',
    mode   => '0644',
  }

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
    user => 'training',
    require => Class['vagrant'],
  }

  # Convert the latest Puppet master instructor OVA and install as a
  # Vagrant box
  vagrant::box { 'current-puppet-master-ova':
    user   => 'training',
    source => 'http://downloads.puppetlabs.com/training/puppet-master.ova',
    require => Class['vagrant'],
  }

  # Convert the latest Puppet master instructor OVA and install as a
  # Vagrant box
  vagrant::box { 'current-puppet-student-ova':
    user   => 'training',
    source => 'http://downloads.puppetlabs.com/training/puppet-student.ova',
    require => Class['vagrant'],
  }

  # Configure the Oscar environment with the proper files to provision
  # a master Vagrant box and the required number of student Vagrant boxes
  $ciab_vagrant_root = '/home/training/classroom_in_a_box'

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

  # Create enough student user accounts that will be used with forwarded
  # ports to login to the student Vagrant boxes
  $student_password_file = '/var/local/student_passwords.txt'

  file { $student_password_file:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  range('1', $::num_students).each |$num| {
    $username = "student${num}"
    $clear_password = random_password(8)
    $salt = random_password(4)

    $crypted_password = pw_hash($clear_password, 'sha-512', $salt)
    notify { "Student ${username} password: ${crypted_password}": }

    file_line { "${username} password entry":
      ensure  => present,
      path    => $student_password_file,
      line    => "${username}:${clear_password}",
      match   => "^${username}:",
      require => File[$student_password_file],
    }
  }

}
