locals {
  docker_context = "${path.root}/app/${var.project_name}"
}

resource "docker_image" "app_image" {
  provider = docker
  name         = "${var.project_name}:${var.image_version}"
  keep_locally = true

  build {
    context    = local.docker_context
    dockerfile = "Dockerfile"
  }

  triggers = {
    build_version = var.image_version
  }
}
resource "docker_container" "app_container" {
  provider = docker
  name  = "${var.project_name}-${var.image_version}"
  image = docker_image.app_image.image_id
  restart = "always"

  ports {
    internal = var.internal_port
    external = var.external_port
  }
  
  volumes {
    host_path      = abspath("${var.host_log_path}/${var.project_name}")     # 宿主机日志目录
    container_path = var.container_log_path # 容器内日志目录
  }

  depends_on = [docker_image.app_image]
}
