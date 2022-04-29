resource "huaweicloud_as_configuration" "default" {
  scaling_configuration_name = var.as_config_name

  instance_config {
    flavor   = var.flavor_id
    image    = var.image_id
    key_name = var.keypair_name

    disk {
      disk_type   = "SYS"
      volume_type = "GPSSD"
      size        = 40
    }
  }
}

resource "huaweicloud_as_group" "default" {
  count = 2

  scaling_group_name       = var.as_group_name
  scaling_configuration_id = huaweicloud_as_configuration.default.id
  vpc_id                   = var.vpc_id

  max_instance_number    = 3
  min_instance_number    = 0
  desire_instance_number = 2

  delete_instances = "yes"
  delete_publicip  = true

  cool_down_time = 86400

  networks {
    id = var.network_id
  }

  security_groups {
    id = var.secgroup_id
  }
}
