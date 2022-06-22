variable "vpc_name" {
  description = "The name of the Huaweicloud VPC"
  default     = "script_evs_multiattach_vpc"
}

variable "subnet_name" {
  description = "The name of the Huaweicloud Subnet"
  default     = "script_evs_multiattach_subnet"
}

variable "security_group_name" {
  description = "The name of the Huaweicloud Security Group"
  default     = "script_evs_multiattach_secgroup"
}

variable "ecs_instance_name" {
  description = "The name of the Huaweicloud RDS instance"
  default     = "script_evs_multiattach_ecs_instance"
}

variable "remote_ip" {
  description = "IP address of the HuaweiCloud EIP"
}

variable "data_count" {
  description = "The DATA total numbers of the HuaweiCloud EVS volume"
  default     = 1
}

variable "flash_count" {
  description = "The FLASH total numbers of the HuaweiCloud EVS volume"
  default     = 1
}

variable "ocr_count" {
  description = "The OCR total numbers of the HuaweiCloud EVS volume"
  default     = 3
}
