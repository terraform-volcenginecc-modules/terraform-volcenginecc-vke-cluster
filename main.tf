resource "volcenginecc_vke_cluster" "this" {
  for_each = var.clusters

  # Cloud Control does not currently return MonitoringConfig consistently.
  lifecycle {
    ignore_changes = [monitoring_config]
  }

  name                      = each.value.name
  description               = each.value.description
  project_name              = each.value.project_name
  kubernetes_version_create = each.value.kubernetes_version
  delete_protection_enabled = each.value.delete_protection_enabled

  cluster_config = merge(
    {
      subnet_ids                             = each.value.control_plane_subnet_ids
      api_server_public_access_enabled       = each.value.api_server_public_access_enabled
      resource_public_access_default_enabled = each.value.resource_public_access_default_enabled
    },
    each.value.api_server_public_access_config == null ? {} : {
      api_server_public_access_config = {
        public_access_network_config = each.value.api_server_public_access_config
      }
    },
  )

  pods_config = merge(
    {
      pod_network_mode = each.value.pod_network_mode
    },
    each.value.pod_network_mode == "Flannel" ? {
      flannel_config = {
        pod_cidrs         = each.value.pod_cidrs
        max_pods_per_node = each.value.max_pods_per_node
      }
    } : {},
    each.value.pod_network_mode == "VpcCniShared" ? {
      vpc_cni_config = {
        subnet_ids        = each.value.pod_subnet_ids
        trunk_eni_enabled = each.value.trunk_eni_enabled
      }
    } : {},
  )

  services_config = {
    service_cidrsv_4 = each.value.service_cidrs
  }

  logging_config = each.value.logging == null ? null : {
    log_project_id = each.value.logging.log_project_id
    log_setups = [
      for log_type, setup in each.value.logging.log_setups : {
        log_type = log_type
        enabled  = setup.enabled
        log_ttl  = setup.log_ttl
      }
    ]
  }

  monitoring_config = each.value.monitoring == null ? null : merge(
    {
      component_configs = [
        for name, enabled in each.value.monitoring.components : {
          name    = name
          enabled = enabled
        }
      ]
    },
    each.value.monitoring.workspace_id == null ? {} : { workspace_id = each.value.monitoring.workspace_id },
    each.value.monitoring.enable_metrics_external_collection == null ? {} : {
      enable_metrics_external_collection = each.value.monitoring.enable_metrics_external_collection
    },
  )

  irsa_config = each.value.irsa_enabled == null ? null : {
    enabled = each.value.irsa_enabled
  }

  tags = [
    for key, value in each.value.tags : {
      key   = key
      value = value
    }
  ]
}

resource "volcenginecc_vke_kubeconfig" "this" {
  for_each = {
    for key, cluster in var.clusters : key => cluster.kubeconfig
    if cluster.kubeconfig != null
  }

  cluster_id     = volcenginecc_vke_cluster.this[each.key].cluster_id
  type           = each.value.type
  valid_duration = each.value.valid_duration
}
