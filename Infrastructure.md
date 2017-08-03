# Infrastructure Setup

The provisioning system depends on a central master, hosted at http://classroom.puppet.com

This master will be configured using classes in the `puppetlabs/bootstrap`
module and a control repository.

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
    NBTZfOlPvMlAesyr4bUY4I5XeVbVk38XKxeriH69EFAD4CahIZlC8lkE/uDh
    jJGQfh052eonkungHIcuGKY/5sEbbZl/qufjAtp/ufor15VBJtsXt17tXP4y
    l5ZP119Fwq8xiREGOL0lVvFYJz2hZc1ppPCNG5lwuLnTekXN/OazNYpf4CMd
    /HjZFXwcXRtTlzewJLc+/gox2IfByQRhsI/AgogRfYQKocZgFb/DOZoXR7wm
    IZGeunzwhqfmEtGiqpvJJQ5wVRdzJVpTnANBA5qxeA==]
bootstrap::profile::provisioner:psk: figaro
```


## Control repository

The control repository will contain just a `Puppetfile` with entries for this
`puppetlabs/bootstrap` module and all dependencies. It should be **pinned to release versions**.

Optionally, Hiera can live in the control repo?

This repository should be configured with a webhook to trigger code deployment
to `classroom.puppet.com` when updated. The release process will then become
simply updating the `Puppetfile` entry to point at the desired module versions.


### Alternate channels.

Instructors can provision machines for *testing* or *beta* channels. This will map to
Puppet environments and control repo branches.


## HA, failover, provisioning, security validation, etc.

TBD


## Status

Planning
