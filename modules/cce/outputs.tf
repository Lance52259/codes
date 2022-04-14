output "cluster_ids" {
  value = huaweicloud_cce_cluster.default[*].id
}