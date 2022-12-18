# Bastion section

resource "random_string" "random_name" {
  length  = 5
  special = false
}

module "bastion_flavor" {
  source               = "../../terraform-examples/modules/vpc/flavor"
  flavor_name          = "flavor-bastion-${random_string.random_name.result}"
  flavor_vcpus         = var.server_vcpus
  flavor_ram_mb        = var.server_ram_mb
}

module "instances" {
  depends_on = [
    module.bastion_flavor
  ]

  source = "../_compute_unit"
  flavor_id = module.bastion_flavor.flavor_id
  server_image_name = var.server_image_name
  server_name = var.server_name
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


module "floatingip" {
  source = "../../terraform-examples/modules/vpc/floatingip"
}

resource "openstack_networking_floatingip_associate_v2" "association_1" {
  port_id     = module.instances.server_port_id
  floating_ip = module.floatingip.floatingip_address
}
