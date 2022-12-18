
# Kubernetes cluster section
module "kubernetes_cluster" {
  source = "../../terraform-examples/modules/mks/cluster"

  cluster_name                      = var.cluster_name
  project_id                        = var.project_id
  region                            = var.region
  kube_version                      = var.kube_version
  enable_autorepair                 = var.enable_autorepair
  enable_patch_version_auto_upgrade = var.enable_patch_version_auto_upgrade
  network_id                        = var.network_id
  subnet_id                         = var.subnet_id
  maintenance_window_start          = var.maintenance_window_start
}

module "kubernetes_nodegroup" {
  source = "../../terraform-examples/modules/mks/nodegroup"
  count = var.worker_nodes_count != 0 ? 1 : 0

  cluster_id        = module.kubernetes_cluster.cluster_id
  project_id        = module.kubernetes_cluster.project_id
  region            = module.kubernetes_cluster.region
  availability_zone = "${var.region}${var.availability_zone}"
  nodes_count       = var.worker_nodes_count
  keypair_name      = ""
  affinity_policy   = var.worker_affinity_policy
  cpus              = var.worker_cpus
  ram_mb            = var.worker_ram_mb
  volume_gb         = var.worker_volume_gb
  volume_type       = "${var.worker_volume_type}.${var.region}${var.availability_zone}"
  labels            = var.worker_labels
  taints            = var.worker_taints

  depends_on = [
    module.kubernetes_cluster
  ]
}

module "kubernetes_system_nodegroup" {
  source = "../../terraform-examples/modules/mks/nodegroup"
  count = var.system_nodes_count != 0 ? 1 : 0

  cluster_id        = module.kubernetes_cluster.cluster_id
  project_id        = module.kubernetes_cluster.project_id
  region            = module.kubernetes_cluster.region
  availability_zone = "${var.region}${var.availability_zone}"
  nodes_count       = var.system_nodes_count
  keypair_name      = ""
  affinity_policy   = var.system_affinity_policy
  cpus              = var.system_cpus
  ram_mb            = var.system_ram_mb
  volume_gb         = var.system_volume_gb
  volume_type       = "${var.system_volume_type}.${var.region}${var.availability_zone}"
  labels            = var.system_labels
  taints            = var.system_taints

  depends_on = [
    module.kubernetes_cluster
  ]
}

module "kubernetes_front_nodegroup" {
  source = "../../terraform-examples/modules/mks/nodegroup"
  count = var.front_nodes_count != 0 ? 1 : 0

  cluster_id        = module.kubernetes_cluster.cluster_id
  project_id        = module.kubernetes_cluster.project_id
  region            = module.kubernetes_cluster.region
  availability_zone = "${var.region}${var.availability_zone}"
  nodes_count       = var.front_nodes_count
  keypair_name      = ""
  affinity_policy   = var.front_affinity_policy
  cpus              = var.front_cpus
  ram_mb            = var.front_ram_mb
  volume_gb         = var.front_volume_gb
  volume_type       = "${var.front_volume_type}.${var.region}${var.availability_zone}"
  labels            = var.front_labels
  taints            = var.front_taints

  depends_on = [
    module.kubernetes_cluster
  ]
}
