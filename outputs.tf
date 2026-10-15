output "clusters" {
  description = "Managed VKE cluster details keyed by the input clusters map key."
  value = {
    for key, cluster in volcenginecc_vke_cluster.this : key => {
      id                       = cluster.id
      cluster_id               = cluster.cluster_id
      name                     = cluster.name
      kubernetes_version       = cluster.kubernetes_version
      status                   = cluster.status.phase
      control_plane_vpc_id     = cluster.cluster_config.vpc_id
      control_plane_subnet_ids = cluster.cluster_config.subnet_ids
      security_group_ids       = cluster.cluster_config.security_group_ids
      api_server_private_ipv4  = try(cluster.cluster_config.api_server_endpoints.private_ip.ipv_4, null)
      api_server_public_ipv4   = try(cluster.cluster_config.api_server_endpoints.public_ip.ipv_4, null)
      irsa_issuer              = try(cluster.irsa_config.issuer, null)
      irsa_oidc_trn            = try(cluster.irsa_config.oidc_trn, null)
      created_time             = cluster.created_time
      updated_time             = cluster.updated_time
    }
  }
}

output "cluster_ids" {
  description = "VKE cluster IDs keyed by logical cluster name."
  value       = { for key, cluster in volcenginecc_vke_cluster.this : key => cluster.cluster_id }
}

output "api_server_endpoints" {
  description = "API Server endpoint addresses keyed by logical cluster name. These are connection metadata, not credentials."
  value = {
    for key, cluster in volcenginecc_vke_cluster.this : key => {
      private_ipv4 = try(cluster.cluster_config.api_server_endpoints.private_ip.ipv_4, null)
      public_ipv4  = try(cluster.cluster_config.api_server_endpoints.public_ip.ipv_4, null)
    }
  }
}

output "kubeconfigs" {
  description = "Generated kubeconfigs keyed by logical cluster name. Terraform masks this output, but the Provider stores it in state."
  value       = { for key, kubeconfig in volcenginecc_vke_kubeconfig.this : key => kubeconfig.kubeconfig }
  sensitive   = true
}
