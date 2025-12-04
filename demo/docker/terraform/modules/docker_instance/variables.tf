variable "image_version" {
  type        = string
  description = "镜像版本号 (例如 v1, v2, v3)"
}

variable "external_port" {
  type        = number
  description = "宿主机映射端口"
}

variable "internal_port" {
  type        = number
  default     = 80
  description = "容器内部端口 (默认 80，可配置化)"
}

variable "project_name" {
  type        = string
  description = "项目名称"
}


variable "host_log_path" {
  type = string
  default = "./logs/"
  description = "宿主机路径"
}

variable "container_log_path" {
  type = string
  default = "/app/logs"
  description = "容器路径"
}

# variable "tar_dir" {
#   type        = string
#   description = "需要打包的目录，基于当前项目目录下的相对路径"
# }

#
# variable "tar_file" {
#   type        = string
#   description = "打包后的压缩文件路径"
# }