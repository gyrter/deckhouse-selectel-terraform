variable "nat_network_id" {}

variable "nat_subnet_id" {}

variable "key_pair_name" {}

variable "availability_zone" {}

variable "server_image_name" {
  default = "Ubuntu 22.04 LTS 64-bit"
}

variable "server_root_disk_gb" {
  default = 10
}

variable "server_vcpus" {
  default = 1
}

variable "server_ram_mb" {
  default = 512
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
  default = "bastion"
}

variable "lb_sngl_name" {
  default = "bastion-lb"
}

variable "lb_sngl_flavor_uuid" {
  default = "78dbe17b-0358-47db-a933-7f06e58307e4"
}

variable "lb_sngl_components" {
  default = {
    component_1 = {
      listener_protocol      = "TCP"
      listener_protocol_port = 22
      monitor_type           = "TCP"
      monitor_delay          = 20
      monitor_timeout        = 10
      monitor_retries        = 5
      pool_lb_method         = "LEAST_CONNECTIONS"
      pool_protocol          = "TCP"
      member_protocol_port   = 80
    }
  }
}
