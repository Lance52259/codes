output "eip_ids" {
  value = huaweicloud_vpc_eip.default[*].id
}