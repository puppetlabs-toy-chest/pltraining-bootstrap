class bootstrap::profile::pe_master (
  $pre_release = false,
  $pe_version  = $bootstrap::params::pe_version,
) inherits bootstrap::params {

  if defined('$pe_server_version') and versioncmp($::pe_server_version, $pe_version) < 0 {
    fail("\n\nPE version ${pe_version} has been released for classroom usage. Please discard this VM and build a new one.\n\n")
  }

  $hieradata            = "${bootstrap::params::codedir}/environments/production/hieradata"
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

  file { '/opt/pltraining/etc/pe.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('bootstrap/pe.conf.erb'),
    notify  => Exec['install pe'],
  }

  # Ensure that the redirect setting persists post install
  # This should be replaced by filesync as soon as the classroom is classified.
  user { 'pe-puppet':
    ensure => present,
  }
  file { dirtree($hieradata, '/etc/puppetlabs'):
    ensure => directory,
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode  => '0644',
  }
  file { "${hieradata}/common.yaml":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    content => 'puppet:///modules/bootstrap/hieradata/common.yaml',
    notify  => Exec['install pe'],
  }

  exec { 'install pe':
    command     => "${destination}/puppet-enterprise-installer -D -c /opt/pltraining/etc/pe.conf",
    refreshonly => true,
    timeout     => 1200,
    before      => Class['bootstrap::profile::cache_rpms'],
  }

}
