# Bootstrap module for Puppet Training VMs

This module is used to build all classroom training VMs. Each supported role is managed via a
single role class. The standard classroom VM is managed via the `bootstrap::role::master` role.

These classes are designed to be idempotent, so classroom VMs can be run against this
classification to receive updates. This is automated via the
[first install bootstrap script](https://github.com/puppetlabs/education-infrastructure-classroom/blob/production/site/profile/templates/provisioning/bootstrap.sh.erb)
and by the [classroom manager](https://github.com/puppetlabs/puppet-classroom-manager).

## Module Quirks

For the most part, this is a fairly standard module. It preconfigures the machine with local
yum & gem repositories that can be used when running in offline mode, preinstalls Docker
and images, pre-installs the Puppet Enterprise stack, pre-installs the PDF creation stack,
etc. There are a few things that may be unexpected though:

* In order to allow the *classroom* command to update modules in the `production` environment,
  this module manages a `Puppetfile`. To update the modules deployed in the classroom VM,
  you should update this [`Puppetfile`](https://github.com/puppetlabs/pltraining-bootstrap/blob/master/files/Puppetfile)
* To provide consistent access to all classroom VMs, even after password randomization or
  changes, we manage an [ssh key](https://github.com/puppetlabs/pltraining-bootstrap/blob/master/files/training.pub),
  which is conveniently the same key as in the courseware repository and used by the deprecated
  `rake ssh` command.
* We [preinstall courseware](https://github.com/puppetlabs/pltraining-bootstrap/blob/master/manifests/profile/courseware.pp)
  on each classroom VM as a git clone of the repository. To authorize that, the classroom master
  has several [keys stored in eyaml](https://github.com/puppetlabs/education-infrastructure-classroom/blob/production/hieradata/common.eyaml)
  that are consumed by classes in this module.
