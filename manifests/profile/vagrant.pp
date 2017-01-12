class bootstrap::profile::vagrant {
  include ::virtualbox

  class { 'vagrant':
    version => '1.9.1',
    require => Class['::virtualbox'],
  }
}
