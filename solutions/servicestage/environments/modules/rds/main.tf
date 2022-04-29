resource "huaweicloud_rds_instance" "default" {
  name              = var.instance_name
  flavor            = "rds.pg.n1.large.2"
  availability_zone = [var.az_names[0]]
  security_group_id = var.secgroup_id
  subnet_id         = var.network_id
  vpc_id            = var.vpc_id
  time_zone         = "UTC+08:00"
  fixed_ip          = "192.168.0.58"

  db {
    password = "Huangwei!120521"
    type     = "PostgreSQL"
    version  = "12"
    port     = 8635
  }

  volume {
    type = "CLOUDSSD"
    size = 50
  }

  backup_strategy {
    start_time = "08:00-09:00"
    keep_days  = 1
  }

  tags = {
    key = "value"
    foo = "bar"
  }
}