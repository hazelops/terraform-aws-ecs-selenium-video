variable "env" {
}

variable "name" {
  default = "selenium-video"
}

variable "environment" {
  type    = map(string)
  default = {}
}

variable "app_secrets" {
  type    = list(string)
  default = []
}


variable "global_secrets" {
  type    = list(string)
  default = []
}

variable "docker_image_name" {
  type    = string
  default = "selenium/video"
}

variable "docker_image_tag" {
  type    = string
  default = "latest"
}

variable "cloudwatch_log_group" {
  default = ""
}

variable "resource_requirements" {
  default = []
}

variable "ecs_launch_type" {}

variable "enabled" {
  default = true
}
