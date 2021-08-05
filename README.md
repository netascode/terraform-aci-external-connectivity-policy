<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-external-connectivity-policy/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-external-connectivity-policy/actions/workflows/test.yml)

# Terraform ACI External Connectivity Policy Module

Description

Location in GUI:
`Tenants` » `infra` » `Policies` » `Protocol` » `Fabric Ext Connection Policies`

## Examples

```hcl
module "aci_external_connectivity_policy" {
  source = "netascode/external-connectivity-policy/aci"

  name         = "EXT-POL1"
  route_target = "extended:as2-nn4:5:17"
  fabric_id    = 2
  site_id      = 2
  bgp_password = "SECRETPW"
  routing_profiles = [{
    name        = "PROF1"
    description = "My Description"
    subnets     = ["10.0.0.0/24"]
  }]
  data_plane_teps = [{
    pod = 2
    ip  = "11.1.1.11"
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | External connectivity policy name. | `string` | n/a | yes |
| <a name="input_route_target"></a> [route\_target](#input\_route\_target) | Route target. | `string` | `"extended:as2-nn4:5:16"` | no |
| <a name="input_fabric_id"></a> [fabric\_id](#input\_fabric\_id) | Fabric ID. Minimum value: 1. Maximum value: 65535. | `number` | `1` | no |
| <a name="input_site_id"></a> [site\_id](#input\_site\_id) | Site ID. Minimum value: 0. Maximum value: 1000. | `number` | `0` | no |
| <a name="input_bgp_password"></a> [bgp\_password](#input\_bgp\_password) | BGP password. | `string` | `""` | no |
| <a name="input_routing_profiles"></a> [routing\_profiles](#input\_routing\_profiles) | External routing profiles. | <pre>list(object({<br>    name        = string<br>    description = optional(string)<br>    subnets     = optional(list(string))<br>  }))</pre> | `[]` | no |
| <a name="input_data_plane_teps"></a> [data\_plane\_teps](#input\_data\_plane\_teps) | Data plane TEPs. Allowed values `pod`: 1-255. | <pre>list(object({<br>    pod = number<br>    ip  = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fvFabricExtConnP` object. |
| <a name="output_name"></a> [name](#output\_name) | External connectivity policy name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.fvFabricExtConnP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvIp](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvPeeringP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fvPodConnP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.l3extFabricExtRoutingP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.l3extSubnet](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->