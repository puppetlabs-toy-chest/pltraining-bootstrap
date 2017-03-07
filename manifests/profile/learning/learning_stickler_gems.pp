class bootstrap::profile::learning::learning_stickler_gems {

  $gems = [
    {
      'gem' => 'cowsay',
      'version' => '0.3.0'
    }
  ]

  $gems.each | Hash $gem | {
    bootstrap::profile::stickler_clone_gem { $gem['gem']:
      version => $gem['version'],
    }
  }

}
