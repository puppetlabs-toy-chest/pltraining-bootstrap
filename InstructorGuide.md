# Building and installing VMs

This document describes the end user experience of building and managing a
next-gen classroom VM. The goal is to provide a "productized" classroom
experience to the instructor.


## Bootstrapping

There are no prerequisites other than a standard CentOS image. This is tested
with the `netinstall` image, but any flavor should work. Once the bootstrap
is completed, the VM will be a standard classroom VM ready for online or offline
use and with the courseware content installed and ready to present.

Instructors can manage their own VMs by installing from ISO, or (recommended)
they can use vagrant with something like the following `Vagrantfile`.

``` Ruby
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "master.puppetlabs.vm"
  config.vm.network :public_network

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8192"
  end
 
  config.vm.provision "shell", inline: "bash <(curl http://classroom.puppet.com/bootstrap.sh) -u you@puppet.com -k figaro"
end
```


### Manual installation

Starting from a fresh CentOS install, simply run the curlbash at the command line
and answer a few questions. This is the only interaction required to build a VM.

```
root@localhost:~ # bash <(curl http://master.puppetlabs.vm/bootstrap.sh)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  2426  100  2426    0     0   294k      0 --:--:-- --:--:-- --:--:--  338k

What is your Puppet email address? ben.ford@puppet.com
What would you like to call this node [ben.ford-2017-07-31]?
Enter the setup key: figaro
Using the values:
      Email: ben.ford@puppet.com
  Node Name: ben.ford-2017-07-31
  Setup Key: figaro

Please Ctrl-C and run again if these are not the values you want.
[...]
```

**Note**: *the slightly different command syntax allows the installer to prompt for input.*


## Presenting in the classroom

The freshly bootstrapped VM has all content installed. Instructors no longer need
to upload content or manage their copy of the `puppet-training/courseware` repository.
Instead, they will simply classify their VM for the class they're preparing to teach.


## Maintaining

VMs can be built fresh for each delivery if desired, but they can also be updated
and reused across deliveries using the `classroom` tool. This tool will

* Update the VM, such as all cached packages, etc.
* Update the courseware content installed on the VM.
* Validate the VM using Serverspec tests.
* Remove certificates and all traces of previous students.
* Submit classroom statistics after the training.
* Run various troubleshooting & metrics tools.

See usage information by gem installing `puppet-classroom-manager` and running `classroom --help`.


## Status

| curlbash installer                | POC         |
| `pltraining/bootstrap` updates    | POC         |
| `classroom` tool                  | in progress |
| `pltraining/classroom` updates    | in progress |
