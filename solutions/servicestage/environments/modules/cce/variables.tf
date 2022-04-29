variable "bandwidth_name" {
  description = "The name of the HuaweiCloud EIP bandwidth"
  default     = "script_servicestage_environments_bandwidth"
}

variable "cluster_name" {
  description = "The name of the HuaweiCloud CCE cluster"
  default     = "script-servicestage-environments-cluster"
}

variable "node_name" {
  description = "The name of the HuaweiCloud CCE node"
  default     = "script-servicestage-environments-node"
}

variable "vpc_id" {}

variable "network_id" {}

variable "az_names" {}

variable "secgroup_id" {}

variable "flavor_id" {}

variable "keypair_name" {}
