# Initialize Selectel provider with token.
provider "selectel" {
  token = var.sel_token
}

module "project_with_user" {
  source = "./terraform-examples/modules/vpc/project_with_user"

  project_name = var.project_name
  user_name = var.user_name
  user_password = var.user_password
  keypair_name = var.keypair_name
}

provider "openstack" {
  auth_url            = "https://api.selvpc.ru/identity/v3"
  region              = var.region
  user_name           = var.user_name
  tenant_id           = module.project_with_user.project_id
  password            = var.user_password
  project_domain_name = regex("[[:digit:]]+$", var.sel_token)
  user_domain_name    = regex("[[:digit:]]+$", var.sel_token)
  use_octavia         = true
}


# Создание SSH ключа
resource "openstack_compute_keypair_v2" "keypair1" {
  count      = var.keypair_name != "" ? 1 : 0
  name       = "${var.keypair_name}-openstack"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create network with external router
module "nat" {
  source = "./terraform-examples/modules/vpc/nat"

  subnet_cidr = var.subnet_cidr

  depends_on = [
    module.project_with_user
  ]
}

# Bastion section
module "bastion" {
  count  = var.is_create_bastion ? 1 : 0
  source = "./modules/bastion"
  depends_on = [
    module.nat,
    module.project_with_user
  ]
  nat_network_id = module.nat.network_id
  nat_subnet_id = module.nat.subnet_id
  server_image_name = var.bastion_server_image_name
  server_vcpus = var.bastion_server_vcpus
  server_ram_mb = var.bastion_server_ram_mb
  server_root_disk_gb = var.bastion_server_root_disk_gb
  region = var.region
  availability_zone = var.availability_zone
  server_volume_type = var.bastion_volume_type
  key_pair_name = "${var.keypair_name}-openstack"
}

# Runners section
module "runners" {
  count  = var.runners_count != 0 ? 1 : 0
  source = "./modules/runners"
  depends_on = [
    module.nat,
    module.project_with_user
  ]
  nat_network_id = module.nat.network_id
  nat_subnet_id = module.nat.subnet_id
  server_image_name = var.runner_server_image_name
  server_vcpus = var.runner_server_vcpus
  server_ram_mb = var.runner_server_ram_mb
  server_root_disk_gb = var.runner_server_root_disk_gb
  region = var.region
  availability_zone = var.availability_zone
  server_volume_type = var.runner_volume_type
  key_pair_name = "${var.keypair_name}-openstack"
  runners_count = var.runners_count
}

# Kubernetes section
module "kubernetes" {
  source = "./modules/kubernetes"

  project_id = module.project_with_user.project_id
  cluster_name = var.cluster_name
  kube_version = var.kube_version
  region = var.region
  network_id = module.nat.network_id
  subnet_id = module.nat.subnet_id

  worker_nodes_count = var.worker_nodes_count
  worker_affinity_policy = var.worker_affinity_policy
  worker_cpus = var.worker_cpus
  worker_ram_mb = var.worker_ram_mb
  worker_volume_gb = var.worker_volume_gb
  worker_volume_type = var.worker_volume_type
  worker_labels = var.worker_labels
  worker_taints = var.worker_taints

  system_nodes_count = var.system_nodes_count
  system_affinity_policy = var.system_affinity_policy
  system_cpus = var.system_cpus
  system_ram_mb = var.system_ram_mb
  system_volume_gb = var.system_volume_gb
  system_volume_type = var.system_volume_type
  system_labels = var.system_labels
  system_taints = var.system_taints

  front_nodes_count = var.front_nodes_count
  front_affinity_policy = var.front_affinity_policy
  front_cpus = var.front_cpus
  front_ram_mb = var.front_ram_mb
  front_volume_gb = var.front_volume_gb
  front_volume_type = var.front_volume_type
  front_labels = var.front_labels
  front_taints = var.front_taints

  depends_on = [
    module.nat,
    module.project_with_user
  ]
}
