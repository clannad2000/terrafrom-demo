terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

locals {
  configs = jsondecode(file("${path.root}/app/configs.json"))
}

module "app" {
  for_each = {
    for app in local.configs : app.project_name => app
  }

  source = "./modules/docker_instance"
  providers = { docker = docker }   # 新式模块传入 provider

  project_name  = each.value.project_name
  image_version = each.value.image_version
  external_port = each.value.external_port
  internal_port = each.value.internal_port
  host_log_path = lookup(each.value, "host_log_path", var.host_log_path)
  container_log_path = lookup(each.value, "container_log_path", var.container_log_path)
}
