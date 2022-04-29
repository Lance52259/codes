output "instance_ids" {
  value = huaweicloud_dcs_instance.default[*].id
}