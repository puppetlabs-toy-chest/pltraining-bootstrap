class bootstrap::params {
  $source_path      = '/usr/src/installer/'
  $admin_user       = 'training'
  $ec2_lock_passwd  = true


  $pe_version       = '2017.1.0'
  $docroot          = '/var/www'
  $psk              = 'figaro'

  $courseware_cache = '/var/cache/courseware'
  $courseware_url   = 'git@github.com:puppet-training/courseware.git'

}
