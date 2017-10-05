class bootstrap::public_key (
  String           $admin_user      = $bootstrap::params::admin_user,
  Boolean          $ec2_lock_passwd = $bootstrap::params::ec2_lock_passwd,
  String           $ssh_key         = $bootstrap::params::admin_ssh_key,
  Optional[String] $additional_key  = undef,
) inherits bootstrap::params {

  ssh_authorized_key { 'instructor':
    user => $admin_user,
    type => 'ssh-rsa',
    key  => $ssh_key,
  }

  if $additional_key {
    # Provide a backup login method, primarily for student masters in Architect.
    # The public half of this key is on the Downloads page of the Courseware presentation
    ssh_authorized_key { 'student@puppet.com':
      ensure => present,
      user   => $admin_user,
      type   => 'ssh-rsa',
      key    => $additional_key,
    }
  }

  if defined('$::ec2_metadata') {
    file {'/etc/cloud/cloud.cfg.d/99_puppetlabs.cfg':
      ensure         => file,
      content        => epp('bootstrap/99_puppetlabs.cfg.epp',{
        admin_user   => $admin_user,
        lock_passwd  => $ec2_lock_passwd,
        ec2_hostname => $::hostname,
      }),
    }
  }

}
