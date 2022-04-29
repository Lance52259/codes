data "huaweicloud_availability_zones" "default" {}

data "huaweicloud_cce_addon_template" "metrics" {
  cluster_id = huaweicloud_cce_cluster.default.id
  name       = "metrics-server"
  version    = "1.2.1"
}

resource "huaweicloud_vpc_eip" "default" {
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    size        = 5
    name        = "test"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_vpc" "default" {
  name = var.vpc_name
  cidr = "192.168.128.0/20"
}

resource "huaweicloud_vpc_subnet" "default" {
  name       = var.subnet_name
  cidr       = "192.168.128.0/24"
  gateway_ip = "192.168.128.1"
  vpc_id     = huaweicloud_vpc.default.id
}

resource "huaweicloud_cce_cluster" "default" {
  flavor_id       = "cce.s2.medium"
  cluster_version = "v1.21"
  cluster_type    = "VirtualMachine"

  vpc_id    = huaweicloud_vpc.default.id
  subnet_id = huaweicloud_vpc_subnet.default.id

  name                   = var.cluster_name
  description            = "Test for master node"
  container_network_type = "vpc-router"
  kube_proxy_mode        = "iptables"
}


resource "huaweicloud_kps_keypair" "default" {
  name = var.keypair_name
}

resource "huaweicloud_cce_node" "default" {
  cluster_id        = huaweicloud_cce_cluster.default.id
  name              = var.node_name
  flavor_id         = "c6s.xlarge.2"
  availability_zone = data.huaweicloud_availability_zones.default.names[0]
  key_pair          = huaweicloud_kps_keypair.default.name

  root_volume {
    size       = 80
    volumetype = "SSD"
  }
  data_volumes {
    size       = 200
    volumetype = "SSD"
  }
}

resource "huaweicloud_cce_addon" "metrics" {
  depends_on = [
    huaweicloud_cce_node.default
  ]
  cluster_id = huaweicloud_cce_cluster.default.id

  template_name = data.huaweicloud_cce_addon_template.metrics.name
  version       = data.huaweicloud_cce_addon_template.metrics.version

  values {
    basic_json  = jsonencode(jsondecode(data.huaweicloud_cce_addon_template.metrics.spec).basic)
    flavor_json = jsonencode(jsondecode(data.huaweicloud_cce_addon_template.metrics.spec).parameters.flavor2)
  }
}