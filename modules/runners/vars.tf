variable "nat_network_id" {}

variable "nat_subnet_id" {}

variable "key_pair_name" {}

variable "availability_zone" {}

variable "runners_count" {
  default = 1
}

variable "server_image_name" {
  default = "Ubuntu 22.04 LTS 64-bit"
}

variable "server_root_disk_gb" {
  default = 20
}

variable "server_vcpus" {
  default = 2
}

variable "server_ram_mb" {
  default = 8192
}

variable "region" {
  default = "ru-3"
}

variable "server_volume_type" {
  default = "fast"
}

variable "server_license_type" {
  default = ""
}

variable "server_name" {
  default = "gitlab-runner"
}
