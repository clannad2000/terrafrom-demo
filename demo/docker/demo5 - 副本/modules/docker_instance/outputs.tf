output "container_id" {
  value = docker_container.app_container.id
}

output "image_full_name" {
  value = docker_image.app_image.name
}
