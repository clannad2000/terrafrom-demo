variable "image_name" {
  type        = string
  description = "镜像基础名称 (例如 nginx_app1, nginx_app2)"
}

variable "image_version" {
  type        = string
  description = "镜像版本号 (例如 v1, v2, v3)"
}
#
# variable "container_name" {
#   type        = string
#   description = "容器名称"
# }

# variable "external_port" {
#   type        = number
#   description = "宿主机映射端口"
# }
#
# variable "internal_port" {
#   type        = number
#   default     = 80
#   description = "容器内部端口 (默认 80，可配置化)"
# }

variable "port_mappings" {
  type = list(object({
    internal = number
    external = number
  }))
  default = [
    { internal = 80, external = 8080 },
    { internal = 443, external = 8443 }
  ]
}

# variable "dockerfile_path" {
#   type        = string
#   description = "Dockerfile 的绝对路径（如 {path.root}/项目目录/Dockerfile）"
# }
