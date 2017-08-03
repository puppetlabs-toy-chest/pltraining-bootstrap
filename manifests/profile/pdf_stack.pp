class bootstrap::profile::pdf_stack {
  $admin_user = $bootstrap::params::admin_user
  
  $fonts = [
    'ucs-miscfixed-fonts.noarch',
    'xorg-x11-fonts-75dpi.noarch',
    'xorg-x11-fonts-Type1.noarch',
    'open-sans-fonts.noarch',
    'google-droid-sans-mono',
  ]
  
  yumrepo { 'robert-gcj':
    ensure              => 'present',
    baseurl             => 'https://copr-be.cloud.fedoraproject.org/results/robert/gcj/epel-7-$basearch/',
    descr               => 'Copr repo for gcj owned by robert',
    enabled             => '1',
    gpgcheck            => '1',
    gpgkey              => 'https://copr-be.cloud.fedoraproject.org/results/robert/gcj/pubkey.gpg',
    skip_if_unavailable => 'true',
  }

  yumrepo { 'robert-pdftk':
    ensure              => 'present',
    baseurl             => 'https://copr-be.cloud.fedoraproject.org/results/robert/pdftk/epel-7-$basearch/',
    descr               => 'Copr repo for pdftk owned by robert',
    enabled             => '1',
    gpgcheck            => '1',
    gpgkey              => 'https://copr-be.cloud.fedoraproject.org/results/robert/pdftk/pubkey.gpg',
    skip_if_unavailable => 'true',
    require             => Yumrepo['robert-gcj'],
  }

  package { 'pdftk':
    ensure  => present,
    require => [Yumrepo['robert-pdftk'],Package[$fonts]],
  }

  package { 'wkhtmltopdf':
    ensure   => present,
    source   => 'https://s3-us-west-2.amazonaws.com/education-packages/wkhtmltopdf-0.12.4_puppet_education-1.x86_64.rpm',
    provider => 'rpm',
    require  => Package[$fonts],
  }

  package { $fonts:
    ensure  => present,
    require => Class['bootstrap::profile::cache_rpms'],
  }
  
  # This must be installed before the eventmachine gem so we get https support
  package { 'openssl-devel':
    ensure => present,
  }

  # this puts in the default courseware so initial classification doesn't fail
  file { "/home/${admin_user}/courseware":
    ensure  => directory,
    owner   => $admin_user,
    group   => $admin_user,
    recurse => true,
    source  => 'puppet:///modules/bootstrap/default_courseware',
  }
}
