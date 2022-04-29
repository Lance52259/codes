variable "as_group_name" {
  description = "The name of the HuaweiCloud AutoScaling group"
  default     = "script_servicestage_environments_group"
}

variable "as_config_name" {
  description = "The name of the HuaweiCloud AutoScaling configuration"
  default     = "script_servicestage_environments_config"
}

variable "flavor_id" {}

variable "image_id" {}

variable "keypair_name" {}

variable "vpc_id" {}

variable "network_id" {}

variable "secgroup_id" {}
