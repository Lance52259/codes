variable "instance_name" {
  description = "The name of the HuaweiCloud ECS instance"
  default     = "script_servicestage_environments_ecs_instance"
}

variable "flavor_id" {}

variable "image_id" {}

variable "az_names" {}

variable "keypair_name" {}

variable "network_id" {}

variable "secgroup_id" {}
