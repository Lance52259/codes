# module "cce_service" {
#   source = "./modules/cce"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id

#   vpc_id       = huaweicloud_vpc.default.id
#   network_id   = huaweicloud_vpc_subnet.default.id
#   az_names     = data.huaweicloud_availability_zones.default.names
#   secgroup_id  = huaweicloud_networking_secgroup.default.id
#   flavor_id    = data.huaweicloud_compute_flavors.default.ids[0]
#   keypair_name = huaweicloud_compute_keypair.default.name
# }

# module "cci_service" {
#   source = "./modules/cci"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id

#   vpc_id      = huaweicloud_vpc.default.id
#   az_name     = data.huaweicloud_availability_zones.default.names[0]
#   secgroup_id = huaweicloud_networking_secgroup.default.id
# }

# module "ecs_service" {
#   source = "./modules/ecs"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id
#   user_id     = var.user_id

#   image_id     = data.huaweicloud_images_image.default.id
#   flavor_id    = data.huaweicloud_compute_flavors.default.ids[0]
#   az_names     = data.huaweicloud_availability_zones.default.names
#   keypair_name = huaweicloud_compute_keypair.default.name
#   network_id   = huaweicloud_vpc_subnet.default.id
#   secgroup_id  = huaweicloud_networking_secgroup.default.id
# }

module "as_service" {
  source = "./modules/as"

  access_key  = var.access_key
  secret_key  = var.secret_key
  domain_name = var.domain_name
  project_id  = var.project_id

  image_id     = data.huaweicloud_images_image.default.id
  flavor_id    = data.huaweicloud_compute_flavors.default.ids[0]
  keypair_name = huaweicloud_compute_keypair.default.name
  vpc_id       = huaweicloud_vpc.default.id
  network_id   = huaweicloud_vpc_subnet.default.id
  secgroup_id  = huaweicloud_networking_secgroup.default.id
}

# module "elb_service" {
#   source = "./modules/elb"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id

#   az_names            = data.huaweicloud_availability_zones.default.names
#   subnet_id           = huaweicloud_vpc_subnet.default.subnet_id
#   network_id          = huaweicloud_vpc_subnet.default.id
#   access_ip_addresses = module.ecs_service.access_ip_addresses
#   vpc_id              = huaweicloud_vpc.default.id
#   vpc_cidr            = huaweicloud_vpc.default.cidr
#   secgroup_id         = huaweicloud_networking_secgroup.default.id
# }

# module "eip_service" {
#   source = "./modules/eip"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id
# }

# module "rds_service" {
#   source = "./modules/rds"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id

#   az_names    = data.huaweicloud_availability_zones.default.names
#   vpc_id      = huaweicloud_vpc.default.id
#   network_id  = huaweicloud_vpc_subnet.default.id
#   secgroup_id = huaweicloud_networking_secgroup.default.id
# }

# module "dcs_service" {
#   source = "./modules/dcs"

#   access_key  = var.access_key
#   secret_key  = var.secret_key
#   domain_name = var.domain_name
#   project_id  = var.project_id

#   az_names            = data.huaweicloud_availability_zones.default.names
#   vpc_id              = huaweicloud_vpc.default.id
#   network_id          = huaweicloud_vpc_subnet.default.id
# }

# resource "huaweicloud_servicestage_environment" "default" {
#   name        = var.environment_name
#   description = "Created by terraform script."
#   vpc_id      = huaweicloud_vpc.default.id

#   basic_resources {
#     cce_ids = module.cce_service.cluster_ids

#     # cci_ids = module.cci_service.namespace_names

#     # ecs_ids = module.ecs_service.instance_ids

#     # as_ids  = module.as_service.as_group_ids
#   }

#   optional_resources {
#   #   elb_ids = module.elb_service.loadbalancer_ids

#   #   eip_ids = module.eip_service.eip_ids

#   #   rds_ids = module.rds_service.instance_ids

#   #   dcs_ids = module.dcs_service.instance_ids

#     cse_ids = ["52e6b7cb-52f8-437d-8f9f-f85f83b34490"]
#   }
# }
