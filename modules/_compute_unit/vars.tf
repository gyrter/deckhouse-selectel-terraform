# compute instance

variable "server_name" {
  default = "gitlab-runner"
}

variable "nat_network_id" {}

variable "nat_subnet_id" {}

variable "flavor_id" {}

variable "key_pair_name" {}

variable "server_image_name" {
  default = "Ubuntu 22.04 LTS 64-bit"
}

variable "server_root_disk_gb" {
  default = 20
}

variable "region" {
  default = "ru-3"
}

variable "server_volume_type" {
  default = "fast.ru-3a"
}

variable "server_zone" {
  default = "ru-3a"
}

variable "server_license_type" {
  default = ""
}

variable "server_vcpus" {
  default = 4
}

variable "server_ram_mb" {
  default = 8192
}

variable "server_preemptible_tag" {
  default = []
}

variable "server_group_id" {
  default = ""
}
