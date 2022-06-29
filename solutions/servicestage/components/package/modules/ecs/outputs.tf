output "instance_id" {
  value = huaweicloud_compute_instance.default.id
}

output "access_ip_address" {
  value = huaweicloud_vpc_eip.default.address
}
