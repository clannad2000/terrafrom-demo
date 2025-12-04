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
module "nginx" {
  source        = "./modules/docker_instance"
  project_name  = "zygk-nginx"
  image_version = "0.0.1"
  external_port = 18080
  internal_port = 18080
}

# 实例 2
module "zygk-basic-management" {
  source        = "./modules/docker_instance"
  project_name  = "zygk-basic-management"
  image_version = "0.0.1"
  external_port = 19510
  internal_port = 19510
}

# 实例 3
module "zygk-external-system" {
  source        = "./modules/docker_instance"
  project_name  = "zygk-external-system"
  image_version = "0.0.1"
  external_port = 19530
  internal_port = 19530
}
