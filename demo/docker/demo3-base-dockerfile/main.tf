terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

# # 实例 1
# module "nginx_app_v1" {
#   source          = "./modules/docker_instance"
#   image_name      = "test-nginx-app1"
#   image_version   = "0.0.1"
#   container_name  = "test-nginx-app1"
#   external_port   = 18080
#   internal_port   = 18080
#   dockerfile_path = "${path.root}/test-nginx-app1"
# }
#
# 实例 2
# module "nginx_app_v1" {
#   source        = "./modules/docker_instance"
#   image_name    = "test-nginx-app1"
#   image_version = "0.0.1"
#   port_mappings = [
#     { internal = 18181, external = 18181 }
#   ]
# }


module "emqx_v1" {
  source        = "./modules/docker_instance"
  image_name    = "emqx"
  image_version = "0.0.1"
  port_mappings = [
    { internal = 1883, external = 1883 },
    { internal = 4370, external = 4370 },
    { internal = 5369, external = 5369 },
    { internal = 8883, external = 8883 },
    { internal = 8083, external = 8083 },
    { internal = 8084, external = 8084 },
    { internal = 18083, external = 18083 }
  ]
}