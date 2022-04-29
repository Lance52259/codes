output "loadbalancer_ids" {
  value = huaweicloud_elb_loadbalancer.default[*].id
}
