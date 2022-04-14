# resource "huaweicloud_vpc_eip" "cce_bind" {
#   count = 2

#   publicip {
#     type = "5_bgp"
#   }

#   bandwidth {
#     share_type  = "PER"
#     size        = 5
#     name        = "${var.bandwidth_name}_${count.index}"
#     charge_mode = "traffic"
#   }
# }

resource "huaweicloud_cce_cluster" "default" {
  count = 2

  name                   = "${var.cluster_name}-${count.index}"
  description            = "Created by terraform script and test for ServiceStage environment."
  vpc_id                 = var.vpc_id // huaweicloud_vpc.default.id
  subnet_id              = var.network_id // huaweicloud_vpc_subnet.default[count.index].id
  flavor_id              = "cce.s2.medium"
  container_network_type = "vpc-router"
  cluster_version        = "v1.19"
  cluster_type           = "VirtualMachine"
  # eip                    = huaweicloud_vpc_eip.cce_bind[count.index].address

  kube_proxy_mode = "iptables"

  dynamic "masters" {
    for_each = slice(var.az_names, 0, 3)

    content {
      availability_zone = masters.value
    }
  }
}

resource "huaweicloud_cce_node" "default" {
  count = 2

  cluster_id        = huaweicloud_cce_cluster.default[count.index].id
  name              = "${var.node_name}-${count.index}"
  flavor_id         = var.flavor_id
  availability_zone = var.az_names[0]
  key_pair          = var.keypair_name

  root_volume {
    volumetype = "SSD"
    size       = 100
  }
  data_volumes {
    volumetype = "SSD"
    size       = 100
  }
}
