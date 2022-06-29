module "ecs_service" {
  source = "./modules/ecs"

  access_key  = var.access_key
  secret_key  = var.secret_key
  project_id  = var.project_id

  flavor_id    = data.huaweicloud_compute_flavors.default.ids[0]
  image_id     = data.huaweicloud_images_image.default.id
  az_names     = data.huaweicloud_availability_zones.default.names
  network_id   = huaweicloud_vpc_subnet.default.id
  secgroup_id  = huaweicloud_networking_secgroup.default.id

  agent_install_cmd = file("command.txt")
}

resource "huaweicloud_servicestage_environment" "default" {
  name        = var.environment_name
  vpc_id      = huaweicloud_vpc.default.id

  basic_resources {
    type = "ecs"
    id   = module.ecs_service.instance_id
  }
}

resource "huaweicloud_servicestage_application" "default" {
  name        = var.application_name
  description = "Created by terraform script."
}

resource "huaweicloud_servicestage_component" "default" {
  application_id = huaweicloud_servicestage_application.default.id

  name      = var.component_name
  type      = "Webapp"
  runtime   = "Java8"
  framework = "Web"

  source {
    type         = "package"
    storage_type = "obs"
    url          = "obs://servicestage-test-1/jar/dli.flink.test-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
  }
}

resource "huaweicloud_servicestage_component_instance" "default" { 
  depends_on = [module.ecs_service.access_ip_address]

  application_id = huaweicloud_servicestage_application.default.id
  component_id   = huaweicloud_servicestage_component.default.id
  environment_id = huaweicloud_servicestage_environment.default.id

  name        = var.instance_name
  version     = "1.0.0"
  replica     = 1
  flavor_id   = "CUSTOM-10G:250m-250m:0.5Gi-0.5Gi" // var.flavor_id
  description = "Created by terraform test"

  # configuration {
  #   strategy {
  #     upgrade = "RollingUpdate"
  #   }
  # }

  artifact {
    version   = "1.0.0"
    name      = var.component_name
    type      = "package"
    storage   = "obs"
    url       = "obs://servicestage-test-1/jar/dli.flink.test-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
    auth_type = "iam"

    properties {
      bucket   = "servicestage-test-1"
      endpoint = "https://obs.cn-north-4.myhuaweicloud.com"
      key      = "jar/dli.flink.test-0.0.1-SNAPSHOT-jar-with-dependencies.jar"
    }
  }

  refer_resource {
    type = "ecs"
    id   = "Default"
    parameters = {
      hosts = "[\"${module.ecs_service.instance_id}\"]"
    }
  }
}
