module "vke_cluster" {
  source  = "terraform-volcenginecc-modules/vke-cluster/volcenginecc"
  version = "~> 1.0"

  clusters = {
    production = {
      name                             = var.cluster_name
      description                      = "Multi-AZ managed Kubernetes cluster for microservices and elastic workloads."
      project_name                     = var.project_name
      control_plane_subnet_ids         = toset(var.control_plane_subnet_ids)
      kubernetes_version               = var.kubernetes_version
      delete_protection_enabled        = var.delete_protection_enabled
      pod_network_mode                 = "VpcCniShared"
      pod_subnet_ids                   = toset(var.pod_subnet_ids)
      trunk_eni_enabled                = var.trunk_eni_enabled
      service_cidrs                    = ["10.96.0.0/16"]
      api_server_public_access_enabled = true
      api_server_public_access_config = {
        bandwidth    = 5
        billing_type = 2
        isp          = "BGP"
      }
      resource_public_access_default_enabled = false
      logging = {
        log_project_id = var.log_project_id
        log_setups = {
          Audit = {
            enabled = true
            log_ttl = 365
          }
          KubeApiServer = {
            enabled = true
            log_ttl = 365
          }
        }
      }
      monitoring = {
        workspace_id                       = var.monitoring_workspace_id
        enable_metrics_external_collection = true
        components                         = var.monitoring_components
      }
      irsa_enabled = true
      tags = {
        Environment = "production"
        ManagedBy   = "terraform"
        Scenario    = "managed-private-multi-az"
        Workload    = "microservices"
      }
    }
  }
}
