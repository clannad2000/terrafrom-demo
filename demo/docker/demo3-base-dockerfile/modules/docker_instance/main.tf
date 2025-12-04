# 构建镜像
resource "docker_image" "app_image" {
  name         = "${var.image_name}:${var.image_version}" //镜像名称+镜像版本
  keep_locally = true

  build {
    context = "${path.root}/${var.image_name}" //dockerfile文件路径
    dockerfile = "Dockerfile"
  }
}

# 部署容器
resource "docker_container" "app_container" {
  name    = var.image_name //容器名称
  image   = docker_image.app_image.image_id
  restart = "always"
#   network_mode = "host"

  dynamic "ports" {
    for_each = var.port_mappings
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  depends_on = [docker_image.app_image]
}
