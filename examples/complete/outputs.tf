output "cluster" {
  description = "Multi-AZ VKE managed cluster details."
  value       = module.vke_cluster.clusters.production
}
