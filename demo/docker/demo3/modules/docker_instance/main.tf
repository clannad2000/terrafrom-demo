# 构建镜像
resource "docker_image" "app_image" {
  name         = "${var.image_name}:${var.image_version}"
  keep_locally = true

  build {
    context = var.dockerfile_path
    dockerfile = "Dockerfile"
  }
}

# 部署容器
resource "docker_container" "app_container" {
  name    = var.container_name
  image   = docker_image.app_image.image_id
  restart = "always"

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  depends_on = [docker_image.app_image]
}
