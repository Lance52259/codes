resource "random_password" "default" {
  length           = 16
  special          = true
  override_special = "!#$%&"
}

resource "huaweicloud_dcs_instance" "default" {
  count = 2

  name               = var.instance_name
  engine_version     = "5.0"
  password           = "Huawei_test"
  engine             = "Redis"
  port               = 6388
  capacity           = 0.125
  vpc_id             = var.vpc_id
  subnet_id          = var.network_id
  availability_zones = [var.az_names[0]]
  flavor             = "redis.ha.xu1.tiny.r2.128"
  maintain_begin     = "22:00:00"
  maintain_end       = "02:00:00"

  backup_policy {
    backup_type = "auto"
    begin_at    = "00:00-01:00"
    period_type = "weekly"
    backup_at   = [4]
    save_days   = 1
  }
}
