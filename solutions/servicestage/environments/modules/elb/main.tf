
resource "huaweicloud_network_acl" "default" {
  name = var.network_acl_name

  subnets = [
    var.network_id,
  ]

  inbound_rules = [
    huaweicloud_network_acl_rule.default.id
  ]
}

resource "huaweicloud_network_acl_rule" "default" {
  name                   = var.network_acl_rule_name
  protocol               = "tcp"
  action                 = "allow"
  source_ip_address      = var.vpc_cidr
  source_port            = "8080"
  destination_ip_address = "0.0.0.0/0"
  destination_port       = "8081"
}

resource "huaweicloud_networking_secgroup_rule" "in_v4_elb_member" {
  security_group_id = var.secgroup_id
  ethertype         = "IPv4"
  direction         = "ingress"
  protocol          = "tcp"
  ports             = "80,8081"
  remote_ip_prefix  = var.vpc_cidr
}

resource "huaweicloud_elb_loadbalancer" "default" {
  count = 2

  name              = "${var.elb_loadbalancer_name}_${count.index}"
  description       = "Created by terraform."
  vpc_id            = var.vpc_id
  ipv4_subnet_id    = var.subnet_id
  ipv6_network_id   = var.network_id

  availability_zone = [
    var.az_names[0]
  ]

  tags = {
    owner = "terraform"
  }
}

resource "huaweicloud_elb_listener" "default" {
  count = 2

  name            = "${var.elb_listener_name}_${count.index}"
  description     = "Created by terraform."
  protocol        = "HTTP"
  protocol_port   = 8080
  loadbalancer_id = huaweicloud_elb_loadbalancer.default[count.index].id

  idle_timeout     = 60
  request_timeout  = 60
  response_timeout = 60

  tags = {
    owner = "terraform"
  }
}

resource "huaweicloud_elb_pool" "default" {
  count = 2

  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = huaweicloud_elb_listener.default[count.index].id

  persistence {
    type = "HTTP_COOKIE"
  }
}

resource "huaweicloud_elb_monitor" "default" {
  count = 2

  protocol    = "HTTP"
  interval    = 20
  timeout     = 15
  max_retries = 10
  url_path    = "/"
  port        = 8080
  pool_id     = huaweicloud_elb_pool.default[count.index].id
}

resource "huaweicloud_elb_member" "default" {
  count = 2

  address       = var.access_ip_addresses[count.index]
  protocol_port = 8080
  pool_id       = huaweicloud_elb_pool.default[count.index].id
  subnet_id     = var.subnet_id
}
