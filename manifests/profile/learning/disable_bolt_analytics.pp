class bootstrap::profile::learning::disable_bolt_analytics {
  file { [ '/root/.puppetlabs', '/root/.puppetlabs/bolt'] :
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
    
  file { '/root/.puppetlabs/bolt/analytics.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "---\ndisabled: true\n",
  }
}
