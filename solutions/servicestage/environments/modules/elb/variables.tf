variable "network_acl_name" {
  description = "The name of the HuaweiCloud ACL"
  default     = "script_servicestage_environments_acl"
}

variable "network_acl_rule_name" {
  description = "The name of the HuaweiCloud ACL rule"
  default     = "script_servicestage_environments_acl_rule"
}

variable "elb_loadbalancer_name" {
  description = "The name of the HuaweiCloud ELB loadbalancer"
  default     = "script_servicestage_environments_loadbalancer"
}

variable "elb_listener_name" {
  description = "The name of the HuaweiCloud ELB listener"
  default     = "script_servicestage_environments_listener"
}

variable "az_names" {}

variable "subnet_id" {}

variable "network_id" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "secgroup_id" {}

variable "access_ip_addresses" {}
