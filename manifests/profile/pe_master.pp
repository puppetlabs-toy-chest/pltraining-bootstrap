class bootstrap::profile::pe_master (
  $pre_release = false,
  $pe_version  = $bootstrap::params::pe_version,
) inherits bootstrap::params {

  if defined('$pe_server_version') and versioncmp($::pe_server_version, $pe_version) < 0 {
    fail("\n\nPE version ${pe_version} has been released for classroom usage. Please discard this VM and build a new one.\n\n")
  }

  $destination          = "/tmp/puppet-enterprise-${pe_version}-el-7-x86_64"
  if $pre_release {
    $installer_filename = "puppet-enterprise-${pe_version}-el-7-x86_64.tar"
    $pe_installer_url   = "http://enterprise.delivery.puppetlabs.net/${PE_FAMILY}/ci-ready/${installer_filename}"
  }
  else {
    $installer_filename = "puppet-enterprise-${pe_version}-el-7-x86_64.tar.gz"
    $pe_installer_url   = "https://s3.amazonaws.com/pe-builds/released/${pe_version}/${installer_filename}"
  }

  archive { "/tmp/${installer_filename}":
    ensure        => present,
    source        => $pe_installer_url,
    extract       => true,
    extract_path  => '/tmp',
    creates       => $destination,
    cleanup       => true,
    notify        => Exec['install pe'],
  }

  file { [ '/opt/pltraining', '/opt/pltraining/etc' ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/opt/pltraining/etc/pe.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('bootstrap/pe.conf.erb'),
    notify  => Exec['install pe'],
  }

  exec { 'install pe':
    command     => "${destination}/puppet-enterprise-installer -D -c /opt/pltraining/etc/pe.conf",
    refreshonly => true,
    timeout     => 1200,
    before      => Class['bootstrap::profile::cache_rpms'],
  }

}
