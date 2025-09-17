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


# 实例 1
module "nginx_app_v1" {
  source          = "./modules/docker_instance"
  image_name      = "test-nginx-app1"
  image_version   = "0.0.1"
  container_name  = "test-nginx-app1"
  external_port   = 18080
  internal_port   = 18080
  dockerfile_path = "${path.root}/test-nginx-app1"
}

# 实例 2
module "nginx_app_v2" {
  source          = "./modules/docker_instance"
  image_name      = "test-nginx-app2"
  image_version   = "0.0.1"
  container_name  = "test-nginx-app2"
  external_port   = 18181
  internal_port   = 18181
  dockerfile_path = "${path.root}/test-nginx-app2"
}
