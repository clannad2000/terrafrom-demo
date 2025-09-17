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

# 构建镜像
resource "docker_image" "mynginx" {
  name         = "mynginx:${var.image_version}"
  keep_locally = false   # 避免旧版本镜像堆积

  build {
    context    = "${path.root}/nginx"
    dockerfile = "Dockerfile"
  }
}

# 部署容器
resource "docker_container" "mynginx_container" {
  name    = "mynginx_container"
  image = docker_image.mynginx.image_id   # 始终使用最新构建
  restart = "always"

  ports {
    internal = 18080
    external = 18080
  }

  depends_on = [docker_image.mynginx]
}
