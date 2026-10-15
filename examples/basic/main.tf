module "vke_cluster" {
  source  = "terraform-volcenginecc-modules/vke-cluster/volcenginecc"
  version = "~> 1.0"

  clusters = {
    basic = {
      name                      = var.cluster_name
      description               = "Private managed Kubernetes cluster for platform engineering."
      control_plane_subnet_ids  = [var.control_plane_subnet_id]
      kubernetes_version        = var.kubernetes_version
      pod_network_mode          = "Flannel"
      pod_cidrs                 = ["172.20.0.0/16"]
      service_cidrs             = ["10.96.0.0/16"]
      delete_protection_enabled = var.delete_protection_enabled

      tags = {
        Environment = "dev"
        ManagedBy   = "terraform"
        Scenario    = "managed-private"
      }
    }
  }
}
