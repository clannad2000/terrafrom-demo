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


# 1. 创建 Docker 卷
resource "docker_volume" "registry_data" {
  name = "registry_data"
}

# 2. 部署 Docker Registry 容器
resource "docker_container" "registry" {
  name    = "registry"
  image   = "registry:2"
  restart = "always"

  ports {
    internal = 5000
    external = 5000
  }

  volumes {
    container_path = "/var/lib/registry"
    volume_name    = docker_volume.registry_data.name
  }
}
