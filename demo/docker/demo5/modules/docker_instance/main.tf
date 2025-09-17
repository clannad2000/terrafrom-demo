locals {
  docker_context = "${path.root}/${var.project_name}"
}

# locals {
#   nginx_files = fileset("${local.docker_context}", "**")
#   nginx_hash = sha256(join("", [
#     for f in local.nginx_files : filesha256("${local.docker_context}/${f}")
#   ]))
# }
#
# # 构建镜像
# resource "docker_image" "app_image" {
#   name         = "${var.project_name}:${var.image_version}"
#   keep_locally = true
#
#   build {
#     context    = local.docker_context
#     dockerfile = "Dockerfile"
# #     no_cache   = false   # 不强制 rebuild
#   }
#   triggers = {
#     nginx_hash = local.nginx_hash  # 文件变化触发 rebuild
#   }
# }



resource "docker_image" "app_image" {
  name = "${var.project_name}:${var.image_version}"

  build {
    context    = local.docker_context
    dockerfile = "Dockerfile"
  }

  triggers = {
    dir_hash = sha256(join("", [
      for f in sort(fileset(local.docker_context, "**")) :
      filesha256("${local.docker_context}/${f}")
    ]))
  }
}

# 部署容器
resource "docker_container" "app_container" {
  name    = var.project_name
  image   = docker_image.app_image.image_id
  restart = "always"

  ports {
    internal = var.internal_port
    external = var.external_port
  }

  depends_on = [docker_image.app_image]
  lifecycle {
    ignore_changes = [
      bridge,
      hostname,
      command,
      entrypoint,
      network_data,
      runtime,
      security_opts,
      exit_code,
      container_logs
    ]
  }
}