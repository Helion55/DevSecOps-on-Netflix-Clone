output "resource_group_name" {
  value = azurerm_resource_group.rgname.name
}

output "client_id" {
  description = "Application id of AzureAD application"
  value       = module.ServicePrincipal.client_id
}

output "client_secret" {
  description = "Password for service principal"
  value       = module.ServicePrincipal.client_secret
  sensitive = true

}
