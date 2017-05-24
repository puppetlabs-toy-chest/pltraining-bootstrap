class bootstrap::profile::learning::learning_stickler_gems {

  $gems = [
    { 'gem' => 'cowsay', 'version' => '0.3.0' },
    { 'gem' => 'pasture', 'version' => '0.2.0' },
    { 'gem' => 'gli', 'version' => '2.13.2' },
    { 'gem' => 'mono_logger', 'version' => '1.1.0' },
    { 'gem' => 'pg', 'version' => '0.19.0' },
    { 'gem' => 'sequel', 'version' => '4.42.1' },
    { 'gem' => 'sinatra', 'version' => '1.4.7' },
    { 'gem' => 'rack', 'version' => '1.6.4' },
    { 'gem' => 'rack-protection', 'version' => '1.5.3' },
    { 'gem' => 'tilt', 'version' => '2.0.5' },
    { 'gem' => 'thin', 'version' => '1.7.0' },
    { 'gem' => 'eventmachine', 'version' => '1.0.4' },
    { 'gem' => 'daemons', 'version' => '1.0.9' },
    { 'gem' => 'webrick', 'version' => '1.3.1' },
  ]

  $gems.each | Hash $gem | {
    bootstrap::profile::stickler_clone_gem { $gem['gem']:
      version => $gem['version'],
    }
  }

}
