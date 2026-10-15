variable "control_plane_subnet_id" {
  type        = string
  description = "Existing subnet ID in the caller-managed VPC for the VKE control plane."
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to request for the VKE cluster."
  default     = "1.32"
}

variable "cluster_name" {
  type        = string
  description = "Unique VKE cluster name for this example."
  default     = "platform-basic"
}

variable "delete_protection_enabled" {
  type        = bool
  description = "Whether VKE deletion protection is enabled. Set false for disposable validation."
  default     = true
}
