# COMPLETE VKE CLUSTER Example

## Overview

Runnable complete configuration for the VKE CLUSTER module. It configures the provider from input variables and calls the published Registry module.

## Usage

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
```

## Requirements

| Name | Version |
|---|---|
| Terraform | `>= 1.5.7` |
| OpenTofu | `>= 1.11.8` |

## Providers

| Name | Source |
|---|---|
| `volcenginecc` | `volcengine/volcenginecc` |

## Resources

| Name | Description |
|---|---|
| `terraform-volcenginecc-modules/vke-cluster/volcenginecc` | Published VKE CLUSTER module. |

## Inputs

| Name | Description |
|---|---|
| `control_plane_subnet_ids` | Module-defined control_plane_subnet_ids. |
| `pod_subnet_ids` | Module-defined pod_subnet_ids. |
| `kubernetes_version` | Module-defined kubernetes_version. |
| `cluster_name` | Module-defined cluster_name. |
| `delete_protection_enabled` | Module-defined delete_protection_enabled. |
| `trunk_eni_enabled` | Module-defined trunk_eni_enabled. |
| `monitoring_components` | Module-defined monitoring_components. |
| `project_name` | Module-defined project_name. |
| `log_project_id` | Module-defined log_project_id. |
| `monitoring_workspace_id` | Module-defined monitoring_workspace_id. |

## Outputs

| Name | Description |
|---|---|
| `cluster` | Module-defined cluster. |

## Examples

This directory is the complete example.

## Notes

- Supply credentials through supported provider configuration, never in source files.
- The final plan after apply must report no changes before the configuration is accepted.
