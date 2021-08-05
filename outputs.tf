output "dn" {
  value       = aci_rest.fvFabricExtConnP.id
  description = "Distinguished name of `fvFabricExtConnP` object."
}

output "name" {
  value       = aci_rest.fvFabricExtConnP.content.name
  description = "External connectivity policy name."
}
