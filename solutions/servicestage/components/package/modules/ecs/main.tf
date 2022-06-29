resource "huaweicloud_compute_instance" "default" {
  name               = var.instance_name
  image_id           = var.image_id
  flavor_id          = var.flavor_id
  availability_zone  = var.az_names[0]
  security_group_ids = [var.secgroup_id]

  admin_pass = "Overlord!!52259"

  network {
    uuid = var.network_id
  }
}

resource "huaweicloud_vpc_eip" "default" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    share_type  = "PER"
    name        = var.bandwidth_name
    size        = 5
    charge_mode = "traffic"
  }
}

resource "huaweicloud_compute_eip_associate" "default" {
  instance_id = huaweicloud_compute_instance.default.id
  public_ip   = huaweicloud_vpc_eip.default.address
}

resource "null_resource" "provision" {
  depends_on = [huaweicloud_compute_eip_associate.default]

  provisioner "remote-exec" {
    connection {
      user     = "root"
      password = "Overlord!!52259"
      host     = huaweicloud_vpc_eip.default.address
    }

    inline = [
      var.agent_install_cmd,
    ]
  }
}