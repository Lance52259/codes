# This script is use to create a CCE cluster and install an add-on

Before using, you should prepare your authorization information in advance, including `domain_name`, `access_key`, `secret_key` and `project_id`.

## Component configuration

* CCE cluster:
  + version: v1.21
  + type: VirtualMachine
  + flavor: cce.s2.medium

* CCE node:
  + flavor: c6s.xlarge.2

* CCE add-on:
  + name: metrics-server
  + version: 1.2.1
