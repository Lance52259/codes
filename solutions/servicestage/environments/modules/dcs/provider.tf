terraform {
  required_providers {
    huaweicloud = {
      # source  = "huaweicloud/huaweicloud"
      source  = "local-registry/huaweicloud/huaweicloud"
      version = "=1.35.1"
    }
    random = {
      source  = "local-registry/random/random"
      version = "=3.0.0"
    }
  }
}

######################################  For test  ######################################
provider "huaweicloud" {
  auth_url    = "https://iam.myhuaweicloud.com:443/v3"
  region      = "cn-north-4" # "ap-southeast-3"
  domain_name = var.domain_name
  # user_name   = var.user_name
  # password    = var.password
  access_key  = var.access_key
  secret_key  = var.secret_key
  project_id  = var.project_id
}
