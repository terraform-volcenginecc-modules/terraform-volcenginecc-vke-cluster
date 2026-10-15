variable "clusters" {
  type = map(object({
    name                                   = string
    control_plane_subnet_ids               = set(string)
    kubernetes_version                     = optional(string)
    description                            = optional(string)
    project_name                           = optional(string)
    delete_protection_enabled              = optional(bool, true)
    api_server_public_access_enabled       = optional(bool, false)
    resource_public_access_default_enabled = optional(bool, false)
    api_server_public_access_config = optional(object({
      bandwidth    = optional(number)
      billing_type = optional(number)
      isp          = optional(string)
    }))
    pod_network_mode  = optional(string, "Flannel")
    pod_cidrs         = optional(set(string), [])
    max_pods_per_node = optional(number, 64)
    pod_subnet_ids    = optional(set(string), [])
    trunk_eni_enabled = optional(bool, false)
    service_cidrs     = optional(set(string), [])
    logging = optional(object({
      log_project_id = optional(string)
      log_setups = optional(map(object({
        enabled = optional(bool, true)
        log_ttl = optional(number, 3650)
      })), {})
    }))
    monitoring = optional(object({
      workspace_id                       = optional(string)
      enable_metrics_external_collection = optional(bool)
      components                         = optional(map(bool), {})
    }))
    irsa_enabled = optional(bool)
    kubeconfig = optional(object({
      type           = string
      valid_duration = optional(number)
    }))
    tags = optional(map(string), {})
  }))
  description = "VKE clusters keyed by stable logical names. The caller owns VPCs, subnets, security groups, NAT gateways, IAM roles, log projects, and monitoring workspaces."

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      length(trimspace(cluster.name)) >= 2 &&
      length(cluster.name) <= 64 &&
      can(regex("^[A-Za-z0-9-]+$", cluster.name)) &&
      length(cluster.control_plane_subnet_ids) > 0 &&
      length(cluster.service_cidrs) > 0
    ])
    error_message = "Each cluster name must be 2-64 ASCII letters, digits, or hyphens, and requires control_plane_subnet_ids and at least one service_cidrs value."
  }

  validation {
    condition = alltrue(flatten([
      for cluster in values(var.clusters) : concat(
        [for cidr in cluster.service_cidrs : can(cidrnetmask(cidr))],
        cluster.pod_network_mode == "Flannel" ? [for cidr in cluster.pod_cidrs : can(cidrnetmask(cidr))] : []
      )
    ]))
    error_message = "service_cidrs and Flannel pod_cidrs must contain valid CIDR blocks."
  }

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      contains(["Flannel", "VpcCniShared"], cluster.pod_network_mode) &&
      (
        cluster.pod_network_mode == "Flannel" ?
        length(cluster.pod_cidrs) > 0 && length(cluster.pod_subnet_ids) == 0 :
        length(cluster.pod_subnet_ids) > 0 && length(cluster.pod_cidrs) == 0
      )
    ])
    error_message = "Flannel requires pod_cidrs and no pod_subnet_ids; VpcCniShared requires pod_subnet_ids and no pod_cidrs."
  }

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      contains([16, 32, 64, 128, 256], cluster.max_pods_per_node)
    ])
    error_message = "max_pods_per_node must be one of 16, 32, 64, 128, or 256."
  }

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      cluster.api_server_public_access_enabled == (cluster.api_server_public_access_config != null) &&
      (
        cluster.api_server_public_access_config == null ? true :
        (
          try(cluster.api_server_public_access_config.bandwidth == null ? true : cluster.api_server_public_access_config.bandwidth > 0, false) &&
          try(cluster.api_server_public_access_config.billing_type == null ? true : contains([2, 3], cluster.api_server_public_access_config.billing_type), false) &&
          try(cluster.api_server_public_access_config.isp == null ? true : cluster.api_server_public_access_config.isp == "BGP", false)
        )
      )
    ])
    error_message = "api_server_public_access_config is required only when public API access is enabled; bandwidth must be positive, billing_type 2 or 3, and isp BGP when set."
  }

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      cluster.logging == null ? true : alltrue([
        for log_type, setup in cluster.logging.log_setups :
        contains(["Audit", "KubeApiServer", "KubeScheduler", "KubeControllerManager"], log_type) &&
        setup.log_ttl > 0
      ])
    ])
    error_message = "Logging supports Audit, KubeApiServer, KubeScheduler, and KubeControllerManager; log_ttl must be positive."
  }

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      length(cluster.tags) <= 50 && alltrue([for key in keys(cluster.tags) : length(trimspace(key)) > 0])
    ])
    error_message = "Each cluster supports at most 50 tags and tag keys cannot be empty."
  }

  validation {
    condition = alltrue([
      for cluster in values(var.clusters) :
      cluster.kubeconfig == null ? true : (
        contains(["Private", "Public"], cluster.kubeconfig.type) &&
        try(cluster.kubeconfig.valid_duration == null ? true : cluster.kubeconfig.valid_duration > 0, false)
      )
    ])
    error_message = "kubeconfig.type must be Private or Public; valid_duration must be positive when set."
  }
}
