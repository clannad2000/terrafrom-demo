output "container_id" {
  description = "容器id"
  value = docker_container.nginx.id
}

output "images_id" {
  description = "镜像id"
  value = docker_image.nginx.id
}