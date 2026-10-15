output "cluster" {
  description = "Private VKE managed cluster details."
  value       = module.vke_cluster.clusters.basic
}
