resource "huaweicloud_compute_instance" "default" {
  count = 2

  name               = var.instance_name
  image_id           = var.image_id
  flavor_id          = var.flavor_id
  availability_zone  = var.az_names[0]
  key_pair           = var.keypair_name
  security_group_ids = [var.secgroup_id]

  network {
    uuid = var.network_id
  }
}
