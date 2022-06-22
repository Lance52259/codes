data "huaweicloud_availability_zones" "default" {}

data "huaweicloud_compute_flavors" "default" {
  availability_zone = data.huaweicloud_availability_zones.default.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "default" {
  name        = "CentOS 7.6 64bit"
  most_recent = true
}

resource "huaweicloud_vpc" "default" {
  name = var.vpc_name
  cidr = "192.168.0.0/20"
}

resource "huaweicloud_vpc_subnet" "public" {
  name       = var.subnet_name
  vpc_id     = huaweicloud_vpc.default.id
  cidr       = "192.168.0.0/24"
  gateway_ip = "192.168.0.1"
}

resource "huaweicloud_vpc_subnet" "private" {
  name       = var.subnet_name
  vpc_id     = huaweicloud_vpc.default.id
  cidr       = "192.168.1.0/24"
  gateway_ip = "192.168.1.1"
}

resource "huaweicloud_networking_secgroup" "default" {
  name                 = var.security_group_name
  delete_default_rules = true
}

resource "huaweicloud_networking_secgroup_rule" "in_v4_tcp_3389" {
  security_group_id = huaweicloud_networking_secgroup.default.id
  ethertype         = "IPv4"
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = "3389"
  port_range_max    = "3389"
  remote_ip_prefix  = var.remote_ip
}

resource "huaweicloud_networking_secgroup_rule" "in_v4_icmp_all" {
  security_group_id = huaweicloud_networking_secgroup.default.id
  ethertype         = "IPv4"
  direction         = "ingress"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "in_v4_icmp_group" {
  security_group_id = huaweicloud_networking_secgroup.default.id
  ethertype         = "IPv4"
  direction         = "ingress"
  remote_group_id   = huaweicloud_networking_secgroup.default.id
}

resource "huaweicloud_networking_secgroup_rule" "in_v6_icmp_group" {
  security_group_id = huaweicloud_networking_secgroup.default.id
  ethertype         = "IPv6"
  direction         = "ingress"
  remote_group_id   = huaweicloud_networking_secgroup.default.id
}

resource "huaweicloud_networking_secgroup_rule" "out_v4_icmp_all" {
  security_group_id = huaweicloud_networking_secgroup.default.id
  ethertype         = "IPv4"
  direction         = "egress"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "out_v6_icmp_all" {
  security_group_id = huaweicloud_networking_secgroup.default.id
  ethertype         = "IPv6"
  direction         = "egress"
  remote_ip_prefix  = "::/0"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  min_numeric      = 1
  min_special      = 1
  min_lower        = 1
  min_upper        = 1
  override_special = "!#"
}

resource "huaweicloud_compute_servergroup" "default" {
  name     = "${var.ecs_instance_name}-servergroup"
  policies = ["anti-affinity"]
}

resource "huaweicloud_compute_instance" "default" {
  count = 2

  name               = format("%s-%d", var.ecs_instance_name, count.index+1)
  image_id           = data.huaweicloud_images_image.default.id
  flavor_id          = data.huaweicloud_compute_flavors.default.ids[0]
  security_groups    = [huaweicloud_networking_secgroup.default.name]
  availability_zone  = data.huaweicloud_availability_zones.default.names[0]

  system_disk_type   = "SSD"
  system_disk_size   = 150

  data_disks {
    type = "SSD"
    size = 200
  }

  admin_pass = random_password.password.result

  network {
    fixed_ip_v4       = "192.168.0.${count.index+2}"
    source_dest_check = false
    uuid              = huaweicloud_vpc_subnet.public.id
  }

  network {
    fixed_ip_v4       = "192.168.1.${count.index+2}"
    source_dest_check = false
    uuid              = huaweicloud_vpc_subnet.private.id
  }

  scheduler_hints {
    group = huaweicloud_compute_servergroup.default.id
  }

  charging_mode = "prePaid"
  period_unit   = "month"
  period        = 1
  auto_renew    = "true"
}

resource "huaweicloud_networking_vip" "default" {
  count = 3

  ip_address = "192.168.0.${count.index+5}"
  network_id = huaweicloud_vpc_subnet.public.id
}

resource "huaweicloud_networking_vip_associate" "default" {
  count = 3

  port_ids = huaweicloud_compute_instance.default[*].network.0.port
  vip_id   = huaweicloud_networking_vip.default[count.index].id
}

resource "huaweicloud_vpc_eip" "default" {
  count = 2

  bandwidth {
    charge_mode = "traffic"
    name        = "${var.ecs_instance_name}_${count.index+1}"
    share_type  = "PER"
    size        = 5
  }

  publicip {
    type = "5_bgp"
  }
}

resource "huaweicloud_compute_eip_associate" "default" {
  count = 2

  instance_id = huaweicloud_compute_instance.default[count.index].id
  public_ip   = huaweicloud_vpc_eip.default[count.index].address
}

resource "huaweicloud_evs_volume" "data" {
  count = var.data_count

  name              = "multi-attach-data-${count.index}"
  availability_zone = data.huaweicloud_availability_zones.default.names[0]

  device_type = "SCSI"
  volume_type = "SSD"
  size        = 10

  multiattach = true

  charging_mode = "prePaid"
  period_unit   = "month"
  period        = 1
  auto_renew    = "true"
}

resource "huaweicloud_evs_volume" "flash" {
  count = var.flash_count

  name              = "multi-attach-flash-${count.index}"
  availability_zone = data.huaweicloud_availability_zones.default.names[0]

  device_type = "SCSI"
  volume_type = "SSD"
  size        = 10

  multiattach = true

  charging_mode = "prePaid"
  period_unit   = "month"
  period        = 1
  auto_renew    = "true"
}

resource "huaweicloud_evs_volume" "ocr" {
  count = var.ocr_count

  name              = "multi-attach-ocr-${count.index}"
  availability_zone = data.huaweicloud_availability_zones.default.names[0]

  device_type = "SCSI"
  volume_type = "SSD"
  size        = 10

  multiattach = true

  charging_mode = "prePaid"
  period_unit   = "month"
  period        = 1
  auto_renew    = "true"
}

resource "huaweicloud_compute_volume_attach" "data_ecs1_attachments" {
  count = var.data_count

  instance_id = huaweicloud_compute_instance.default[0].id
  volume_id   = huaweicloud_evs_volume.data[count.index].id
}

resource "huaweicloud_compute_volume_attach" "data_ecs2_attachments" {
  count = var.data_count

  instance_id = huaweicloud_compute_instance.default[1].id
  volume_id   = huaweicloud_evs_volume.data[count.index].id
}

resource "huaweicloud_compute_volume_attach" "flash_ecs1_attachments" {
  count = var.flash_count

  instance_id = huaweicloud_compute_instance.default[0].id
  volume_id   = huaweicloud_evs_volume.flash[count.index].id
}

resource "huaweicloud_compute_volume_attach" "flash_ecs2_attachments" {
  count = var.flash_count

  instance_id = huaweicloud_compute_instance.default[1].id
  volume_id   = huaweicloud_evs_volume.flash[count.index].id
}

resource "huaweicloud_compute_volume_attach" "ocr_ecs1_attachments" {
  count = var.ocr_count

  instance_id = huaweicloud_compute_instance.default[0].id
  volume_id   = huaweicloud_evs_volume.ocr[count.index].id
}

resource "huaweicloud_compute_volume_attach" "ocr_ecs2_attachments" {
  count = var.ocr_count

  instance_id = huaweicloud_compute_instance.default[1].id
  volume_id   = huaweicloud_evs_volume.ocr[count.index].id
}
