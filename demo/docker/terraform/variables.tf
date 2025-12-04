variable "host_log_path" {
  type = string
  default = "./app/logs/"
  description = "宿主机路径"
}

variable "container_log_path" {
  type = string
  default = "/app/logs"
  description = "容器路径"
}