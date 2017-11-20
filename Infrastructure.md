# Infrastructure Setup

The provisioning system depends on a central master, hosted at http://classroom.puppet.com

This master will be configured using classes in the `puppetlabs/bootstrap`
module and a control repository.

See the [instructor resources on Confluence](https://confluence.puppetlabs.com/display/EDU/%28ALPHA%29+Self-provisioned+training+VMs)


## Classification

* The `classroom.puppet.com` provisioner should be classified with `bootstrap::role::provisioner`.
* All other nodes should be classified with `bootstrap::role::training` (or as appropriate)
* The PE Agent and PE MCollective node groups should be configured to match only `classroom.puppet.com`.


## Hiera

Hiera should contain the private SSH key of a GitHub user with read-only access to
the `puppet-training/courseware` repository. This should be encrypted with `hiera-eyaml`.
It should also contain the pre-shared key used by instructors for bootstrapping.

``` yaml
---
bootstrap::courseware::key: >
    ENC[PKCS7,Y22exl+OvjDe+drmik2XEeD3VQtl1uZJXFFF2NnrMXDWx0csyqLB/2NOWefv
    [......]
    /HjZFXwcXRtTlzewJLc+/gox2IfByQRhsI/AgogRfYQKocZgFb/DOZoXR7wm
    IZGeunzwhqfmEtGiqpvJJQ5wVRdzJVpTnANBA5qxeA==]
bootstrap::profile::provisioner:psk: >
    ENC[PKCS7,MIIBeQYJKoZIhvcNAQcDoIIBajCCAWYCAQAxggEhMIIBHQIBADAFMAACAQEw
    [......]
    WM7H+6VZsqbq9QiKsoe6LoZsbti8Pxly72CBOVWGoSsBpHrhwHS8ArhHobqj
    IL+bkOQTShabV7anyAjehizdSDdsPPRf4qzP9zFlpV2Q+Mrstyp9tdmLgJY6
    gQM+gBBqRO/oMDRUq1lWzQ9tc8SY]
```


## Control repository

The [control repository](https://github.com/puppetlabs/education-infrastructure-classroom)
will contain a `Puppetfile` with entries for this `puppetlabs/bootstrap` module
and all dependencies. It should be **pinned to release versions**.

Hieradata and several profile classes related to the classroom server also live
in this repository.

In the future, this repository will be configured with a webhook to trigger code
deployment to `classroom.puppet.com` when updated. The release process will then
become simply updating the `Puppetfile` entry to point at the desired module
versions. Currently, the release process still requires a manual `puppet code
deploy` on the server.

**Note**: When changes are made to the `pltraining/bootstrap` module, they
***no longer propagate to the field automatically***! Instead, intentional
releases should be made and promoted following a standard release policy.


### Alternate channels.

In the future, instructors will be able to provision machines for *testing* or
*beta* channels. This will map to Puppet environments and control repo branches.


## HA, failover, provisioning, security validation, etc.

Under development.
