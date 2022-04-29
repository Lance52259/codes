variable "namespace_name" {
  description = "The name of the HuaweiCloud CCI namespace"
  default     = "script-servicestage-environments-cci-namespace"
}

variable "subnet_name" {
  description = "The name of the HuaweiCloud VPC subnet"
  default     = "script-servicestage-environments-cci-network-subnet"
}

variable "network_name" {
  description = "The name of the HuaweiCloud CCI network"
  default     = "script-servicestage-environments-cci-network"
}

variable "subnet_config" {
  type = list(object({
    cidr       = string
    gateway_ip = string
  }))
  default = [
    {cidr = "192.168.192.0/18", gateway_ip = "192.168.192.1"},
    {cidr = "192.168.128.0/18", gateway_ip = "192.168.128.1"},
  ]
}

variable "az_name" {}

variable "vpc_id" {}

variable "secgroup_id" {}
