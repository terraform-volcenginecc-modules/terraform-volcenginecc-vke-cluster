# terraform-volcenginecc-vke-cluster

## Overview

Terraform module for managing Volcengine VKE CLUSTER resources with the `volcenginecc` provider. The caller owns provider authentication, region configuration, and external resources passed by ID.

## Usage

```hcl
module "vke_cluster" {
  source  = "terraform-volcenginecc-modules/vke-cluster/volcenginecc"
  version = "~> 1.0"

  # Set the required module inputs for your environment.
}
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
| `volcenginecc_vke_cluster` | Module-defined volcenginecc_vke_cluster. |
| `volcenginecc_vke_kubeconfig` | Module-defined volcenginecc_vke_kubeconfig. |

## Inputs

| Name | Description |
|---|---|
| `clusters` | Module-defined clusters. |

## Outputs

| Name | Description |
|---|---|
| `clusters` | Module-defined clusters. |
| `cluster_ids` | Module-defined cluster_ids. |
| `api_server_endpoints` | Module-defined api_server_endpoints. |
| `kubeconfigs` | Module-defined kubeconfigs. |

## Examples

- `basic`: independently runnable basic configuration.
- `complete`: independently runnable complete configuration.

## Notes

- Configure credentials using supported provider mechanisms; do not put access keys in module files.
- Review replacement behavior and provider constraints before applying changes.
- Run `terraform plan` after apply and confirm that the second plan has no changes.
