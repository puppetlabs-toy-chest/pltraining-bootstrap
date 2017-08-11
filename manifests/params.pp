class bootstrap::params {
  # This set of variables defines releases of the VM and PE versions
  $ptb_version      = '7.0'
  $pe_version       = '2017.1.0'
  $agent_version    = '1.9.3'


  # the following config variables should rarely be touched
  $source_path      = '/usr/src/installer/'
  $admin_user       = 'training'
  $ec2_lock_passwd  = true

  $docroot          = '/var/www'
  $psk              = 'figaro'

  $courseware_cache = '/var/cache/showoff/courseware'
  $courseware_url   = 'git@github.com:puppet-training/courseware.git'

  $stagedir         = '/etc/puppetlabs/code-staging'
  $codedir          = '/etc/puppetlabs/code'
}
