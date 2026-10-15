variable "control_plane_subnet_ids" {
  type        = list(string)
  description = "Existing control-plane subnet IDs from distinct availability zones in a caller-managed VPC."

  validation {
    condition     = length(var.control_plane_subnet_ids) >= 2
    error_message = "Provide at least two control-plane subnets for the multi-AZ example."
  }
}

variable "pod_subnet_ids" {
  type        = list(string)
  description = "Existing VPC-CNI Pod subnet IDs from distinct availability zones."

  validation {
    condition     = length(var.pod_subnet_ids) >= 2
    error_message = "Provide at least two Pod subnets for the multi-AZ example."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to request for the VKE cluster."
  default     = "1.32"
}

variable "cluster_name" {
  type        = string
  description = "Unique VKE cluster name for this example."
  default     = "platform-production"
}

variable "delete_protection_enabled" {
  type        = bool
  description = "Whether VKE deletion protection is enabled. Set false for disposable validation."
  default     = true
}

variable "trunk_eni_enabled" {
  type        = bool
  description = "Whether VPC-CNI Trunk ENI is enabled. This feature may require an account allowlist."
  default     = false
}

variable "monitoring_components" {
  type        = map(bool)
  description = "Optional VKE monitoring components keyed by API-supported component name."
  default     = {}
}

variable "project_name" {
  type        = string
  description = "Optional existing Volcengine project name."
  default     = "default"
}

variable "log_project_id" {
  type        = string
  description = "Existing log project ID for VKE control-plane logs."
}

variable "monitoring_workspace_id" {
  type        = string
  description = "Existing monitoring workspace ID for cluster metrics."
}
