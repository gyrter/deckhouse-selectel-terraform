# kubernetes

variable "cluster_name" {}
variable "project_id" {}
variable "region" {}
variable "network_id" {}
variable "subnet_id" {}

variable "kube_version" {
  default = "1.24.7"
}

variable "enable_autorepair" {
  default = true
}

variable "enable_patch_version_auto_upgrade" {
  default = true
}

variable "maintenance_window_start" {
  default = "02:00:00"
}

variable "availability_zone" {
  default = "a"
}

variable "worker_nodes_count" {
  default = 1
}

variable "worker_affinity_policy" {
  default = ""
}

variable "worker_cpus" {
  default = 4
}

variable "worker_ram_mb" {
  default = 8192
}

variable "worker_volume_gb" {
  default = 50
}

variable "worker_volume_type" {
  default = "fast"
}

variable "worker_labels" {
  default = {
    "node-role.kubernetes.io/worker":"worker"
  }
}

variable "worker_taints" {
  type = list(object({
    key = string
    value = string
    effect =string
  }))
  default =[ ]
}

variable "system_nodes_count" {
  default = 1
}

variable "system_affinity_policy" {
  default = ""
}

variable "system_cpus" {
  default = 4
}

variable "system_ram_mb" {
  default = 16384
}

variable "system_volume_gb" {
  default = 50
}

variable "system_volume_type" {
  default = "fast.ru-3a"
}

variable "system_labels" {
  default = {
    "node-role.kubernetes.io/system":"system"
  }
}

variable "system_taints" {
  type = list(object({
    key = string
    value = string
    effect =string
  }))
  default =[ {
    effect = "NoExecute"
    key = "dedicated.deckhouse.io"
    value = "system"
  } ]
}

variable "front_nodes_count" {
  default = 1
}

variable "front_affinity_policy" {
  default = ""
}

variable "front_cpus" {
  default = 4
}

variable "front_ram_mb" {
  default = 4096
}

variable "front_volume_gb" {
  default = 50
}

variable "front_volume_type" {
  default = "fast.ru-3a"
}

variable "front_labels" {
  default = {
    "node-role.kubernetes.io/frontend":"frontend"
  }
}

variable "front_taints" {
  type = list(object({
    key = string
    value = string
    effect =string
  }))
  default =[ {
    effect = "NoExecute"
    key = "dedicated.deckhouse.io"
    value = "frontend"
  } ]
}
