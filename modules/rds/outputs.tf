output "instance_ids" {
  value = huaweicloud_rds_instance.default[*].id
}
