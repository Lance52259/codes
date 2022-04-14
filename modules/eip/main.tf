resource "huaweicloud_vpc_eip" "default" {
  count = 2

  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "${var.bandwidth_name}_${count.index}"
    size        = 10
    charge_mode = "traffic"
  }
}