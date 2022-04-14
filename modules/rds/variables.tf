
variable "instance_name" {
  description = "The name of the HuaweiCloud RDS instance"
  default     = "script_servicestage_environments_rds_instance"
}

variable "az_names" {}

variable "vpc_id" {}

variable "network_id" {}

variable "secgroup_id" {}
