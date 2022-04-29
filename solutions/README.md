# This script is use to create a CCE cluster and install a add-on

Before you using it, you should prepail your authorization information, includes `domain_name`, `access_key`, `secret_key` and `project_id`.

## Component configuration

* CCE cluster:
  + version: v1.21
  + type: VirtualMachine
  + flavor: cce.s2.medium

* CCE node:
  + flavor: c6s.xlarge.2

* CCE add-on:
  + name: metrics-server
