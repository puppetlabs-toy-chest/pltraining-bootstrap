class bootstrap::params {
  # This set of variables defines releases of the VM and PE versions
  $ptb_version      = '7.0'
  $pe_version       = '2019.0.1'
  $agent_version    = '5.5.8'


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

  # training.pem
  $admin_ssh_key   = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCv+89n9QU8kPxhsoRAHt5CZMy4cyA7vQ8k60wZmyUHnmFtXH8Ipusj9QyV8GsL/F64ci3bS0eHlk5XlAFACsLy4Gai6CQ2NAjkZRT7qG5BtoGr4aGXhxFCUZ2hgo2j18uU6GKl2akRPsYMsRgNrRglidENLY4WUCzacgr/1Cw8eRN95Mo9b4tgSLTCyd/783CBdeM8qU9Go7xq0nVRGNgsFIqf1SY+9k5dpSbL0M5lvDzl35IC1tRIQE/ZbafJok8g1XmhwKokWpGBRk9/GneWz3jDvJRZPjYHzQs+gSHNkl2F6i55EIlQqbfm/7lvtB73Pd2vT+i1AIgrx90YB4Yd'

  # puppet_classroom.pub in the presentation downloads
  $additional_key  = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDT4hxLhcccJhKRHp5uSEpmE3EgXaOlL72qI7T8cJOh/hov/MsCd8IVGc1fE1romqCjS6vITn9L/tPeJOwmGSih0iUWEQd6CY/OZttdnlelwaGke12hPiuqYqEqGcExNrGoynTQWMz99T6cdyd9HptCGdYGK1EwCi3hmv9QBZGChUbnQKqi3Zc1Uubpzp6WyTXaDoxLxlxX7QXt8K7cRaAviDZ/I07svoO9RwZPqGyeeyh4k1pAYTik8jY58rMmDCNcp6jM4AWAF786k77GI/DBzACJ7kt1Qe8fGLlm7UyV/nSZhxiKs3TcfqBypPf+tQzvfvSfRdVvoMQQOw38ogqT'

}
