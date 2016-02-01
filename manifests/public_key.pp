class bootstrap::public_key ( $admin_user = $bootstrap::params::admin_user ) {
  ssh_authorized_key { 'instructor':
    user => $admin_user,
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCv+89n9QU8kPxhsoRAHt5CZMy4cyA7vQ8k60wZmyUHnmFtXH8Ipusj9QyV8GsL/F64ci3bS0eHlk5XlAFACsLy4Gai6CQ2NAjkZRT7qG5BtoGr4aGXhxFCUZ2hgo2j18uU6GKl2akRPsYMsRgNrRglidENLY4WUCzacgr/1Cw8eRN95Mo9b4tgSLTCyd/783CBdeM8qU9Go7xq0nVRGNgsFIqf1SY+9k5dpSbL0M5lvDzl35IC1tRIQE/ZbafJok8g1XmhwKokWpGBRk9/GneWz3jDvJRZPjYHzQs+gSHNkl2F6i55EIlQqbfm/7lvtB73Pd2vT+i1AIgrx90YB4Yd',
  }
}
