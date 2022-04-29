output "namespace_names" {
  value = huaweicloud_cci_namespace.default[*].name
}