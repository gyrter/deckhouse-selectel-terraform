# Runner section

resource "random_string" "random_name" {
  length  = 5
  special = false
}

module "runner_flavor" {
  source               = "../../terraform-examples/modules/vpc/flavor"
  flavor_name          = "flavor-runner-${random_string.random_name.result}"
  flavor_vcpus         = var.server_vcpus
  flavor_ram_mb        = var.server_ram_mb
}

module "instances" {
  count                = var.runners_count

  depends_on = [
    module.runner_flavor
  ]

  source = "../_compute_unit"
  flavor_id = module.runner_flavor.flavor_id
  server_image_name = var.server_image_name
  server_name = "${var.server_name}-${count.index + 1}"
  region = var.region
  server_zone = "${var.region}${var.availability_zone}"
  server_license_type = var.server_license_type
  server_root_disk_gb = var.server_root_disk_gb
  server_volume_type = "${var.server_volume_type}.${var.region}${var.availability_zone}"
  nat_network_id = var.nat_network_id
  nat_subnet_id = var.nat_subnet_id
  key_pair_name = var.key_pair_name
  server_ram_mb = var.server_ram_mb
  server_vcpus = var.server_vcpus
}
