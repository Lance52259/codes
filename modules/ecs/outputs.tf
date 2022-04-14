output "instance_ids" {
  value = huaweicloud_compute_instance.default[*].id
}

output "access_ip_addresses" {
  value = huaweicloud_compute_instance.default[*].access_ip_v4
}

output "secgroup_id" {
  value = huaweicloud_networking_secgroup.default.id
}
