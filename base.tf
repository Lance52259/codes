data "huaweicloud_availability_zones" "default" {}

data "huaweicloud_compute_flavors" "default" {
  availability_zone = data.huaweicloud_availability_zones.default.names[0]
  performance_type  = "normal"
  cpu_core_count    = 8
  memory_size       = 16
}

data "huaweicloud_images_image" "default" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

resource "huaweicloud_compute_keypair" "default" {
  name = var.keypair_name
}

resource "huaweicloud_vpc" "default" {
  name = var.vpc_name
  cidr = "192.168.0.0/16"
}

resource "huaweicloud_vpc_subnet" "default" {
  name        = var.subnet_name
  cidr        = "192.168.0.0/24"
  gateway_ip  = "192.168.0.1"
  vpc_id      = huaweicloud_vpc.default.id
  ipv6_enable = true
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
  ports             = "3389"
  remote_ip_prefix  = format("%s/32", var.pc_ip_address)
}

# resource "huaweicloud_networking_secgroup_rule" "in_v4_icmp_all" {
#   security_group_id = huaweicloud_networking_secgroup.default.id
#   ethertype         = "IPv4"
#   direction         = "ingress"
#   protocol          = "icmp"
#   remote_ip_prefix  = "0.0.0.0/0"
# }

# resource "huaweicloud_networking_secgroup_rule" "in_v4_all_group" {
#   security_group_id = huaweicloud_networking_secgroup.default.id
#   ethertype         = "IPv4"
#   direction         = "ingress"
#   remote_group_id   = huaweicloud_networking_secgroup.default.id
# }

# resource "huaweicloud_networking_secgroup_rule" "in_v6_all_group" {
#   security_group_id = huaweicloud_networking_secgroup.default.id
#   ethertype         = "IPv6"
#   direction         = "ingress"
#   remote_group_id   = huaweicloud_networking_secgroup.default.id
# }

# resource "huaweicloud_networking_secgroup_rule" "out_v4_all" {
#   security_group_id = huaweicloud_networking_secgroup.default.id
#   ethertype         = "IPv4"
#   direction         = "egress"
#   remote_ip_prefix  = "0.0.0.0/0"
# }

# resource "huaweicloud_networking_secgroup_rule" "out_v6_all" {
#   security_group_id = huaweicloud_networking_secgroup.default.id
#   ethertype         = "IPv6"
#   direction         = "egress"
#   remote_ip_prefix  = "::/0"
# }
