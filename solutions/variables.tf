variable "vpc_name" {
  description = "The name of the Huaweicloud VPC"
  default     = "script_cce_clusters_vpc"
}

variable "subnet_name" {
  description = "The name of the Huaweicloud Subnet"
  default     = "script_cce_clusters_subnet"
}

variable "security_group_name" {
  description = "The name of the Huaweicloud Security Group"
  default     = "script_cce_clusters_secgroup"
}

variable "keypair_name" {
  description = "The name of the Huaweicloud DEW secret key"
  default     = "script-cce-clusters-keypair"
}

variable "cluster_name" {
  description = "The name of the Huaweicloud CCE cluster"
  default     = "script-cce-clusters-cluster"
}

variable "node_name" {
  description = "The name of the Huaweicloud CCE node"
  default     = "script-cce-clusters-node"
}