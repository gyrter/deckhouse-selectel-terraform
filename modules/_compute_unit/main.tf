resource "openstack_networking_port_v2" "port_1" {
  name       = "${var.server_name}-eth0"
  network_id = var.nat_network_id

  fixed_ip {
    subnet_id = var.nat_subnet_id
  }
}

module "image_datasource" {
  source     = "../../terraform-examples/modules/vpc/image_datasource"
  image_name = var.server_image_name
}

resource "openstack_blockstorage_volume_v3" "volume_1" {
  name              = "volume-for-${var.server_name}"
  size              = var.server_root_disk_gb
  image_id          = module.image_datasource.image_id
  volume_type       = var.server_volume_type
  availability_zone = var.server_zone

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "openstack_compute_instance_v2" "instance_1" {
  name              = var.server_name
  flavor_id         = var.flavor_id
  key_pair          = var.key_pair_name
  availability_zone = var.server_zone

  network {
    port = openstack_networking_port_v2.port_1.id
  }

  dynamic "network" {
    for_each = var.server_license_type != "" ? [var.server_license_type] : []

    content {
      name = var.server_license_type
    }
  }

  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_1.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

  tags = var.server_preemptible_tag

  vendor_options {
    ignore_resize_confirmation = true
  }

  dynamic "scheduler_hints" {
    for_each = var.server_group_id != "" ? [var.server_group_id] : []
    content {
      group = var.server_group_id
    }
  }
}
