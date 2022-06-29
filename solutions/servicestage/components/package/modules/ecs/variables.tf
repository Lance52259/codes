variable "instance_name" {
  description = "The name of the HuaweiCloud ECS instance"
  default     = "script_servicestage_environments_instances_ecs_instance"
}

variable "bandwidth_name" {
  description = "The name of the HuaweiCloud EIP bandwidth"
  default     = "script_servicestage_environments_instances_eip_bandwidth"
}

variable "flavor_id" {}

variable "image_id" {}

variable "az_names" {}

variable "network_id" {}

variable "secgroup_id" {}

variable "agent_install_cmd" {}
