variable "security_group_name" {
  description = "The name of the HuaweiCloud Security group"
  default     = "script_servicestage_components_ecs_instances_secgroup"
}

variable "pc_ip_address" {
  description = "The IP address of the HongKong computer"
  default     = "202.170.90.223"
}

variable "vpc_name" {
  description = "The name of the HuaweiCloud VPC"
  default     = "script_servicestage_components_ecs_instances_vpc"
}

variable "subnet_name" {
  description = "The name of the HuaweiCloud VPC subnet"
  default     = "script_servicestage_components_ecs_instances_subnet"
}

variable "environment_name" {
  description = "The name of the HuaweiCloud ServiceStage environment"
  default     = "script_servicestage_components_instances_env"
}

variable "application_name" {
  description = "The ID of the ServiceStage Application"
  default     = "script-servicestage-components-instances-application"
}

variable "component_name" {
  description = "The name of the ServiceStage Component"
  default     = "ecs-build-test"
}

variable "instance_name" {
  description = "The name of the ServiceStage Component instance"
  default     = "fusionweather-instance"
}

variable "flavor_id" {
  description = "The custom flavor ID of the ServiceStage Component instance"
  default     = "CUSTOM-10G:250m-250m:0.5Gi-0.5Gi"
}
