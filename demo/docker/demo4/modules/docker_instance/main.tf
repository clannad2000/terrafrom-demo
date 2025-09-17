locals {
  docker_context = "${path.root}/${var.project_name}"
}

locals {
  nginx_files = fileset("${local.docker_context}/${var.tar_dir}", "**")  # 匹配目录下所有文件
  nginx_hash = sha256(join("", [
    for f in local.nginx_files : filesha256("${local.docker_context}/${var.tar_dir}/${f}")
  ]))
}

resource "null_resource" "tar_nginx" {
  triggers = {
    dir_hash = local.nginx_hash
    tar_missing  = fileexists("${local.docker_context}/${var.tar_dir}.tgz") ? "present" : "missing"
  }

  provisioner "local-exec" {
    command = "tar czf ${local.docker_context}/${var.tar_dir}.tgz -C ${local.docker_context}/${var.tar_dir} ."
  }
}

# 构建镜像
resource "docker_image" "app_image" {
  name         = "${var.project_name}:${var.image_version}"
  keep_locally = true

  build {
    context    = local.docker_context
    dockerfile = "Dockerfile"
  }
  depends_on = [null_resource.tar_nginx]
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
}
