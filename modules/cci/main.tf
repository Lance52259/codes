resource "huaweicloud_cci_namespace" "default" {
  count = 2

  name                = "${var.namespace_name}-${count.index}"
  type                = "gpu-accelerated"
  auto_expend_enabled = true
}

resource "huaweicloud_vpc_subnet" "default" {
  count = 2

  name       = "${var.subnet_name}-${count.index}"
  vpc_id     = var.vpc_id
  cidr       = var.subnet_config[count.index].cidr
  gateway_ip = var.subnet_config[count.index].gateway_ip
}

resource "huaweicloud_cci_network" "default" {
  count = 2

  availability_zone = var.az_name
  name              = "${var.network_name}-${count.index}"
  namespace         = huaweicloud_cci_namespace.default[count.index].name
  network_id        = huaweicloud_vpc_subnet.default[count.index].id
  security_group_id = var.secgroup_id
}