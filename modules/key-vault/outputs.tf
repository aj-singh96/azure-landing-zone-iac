output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

output "private_endpoint_id" {
  description = "The ID of the private endpoint (if created)"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.key_vault[0].id : null
}

output "private_endpoint_ip" {
  description = "The private IP address of the private endpoint (if created)"
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.key_vault[0].private_service_connection[0].private_ip_address : null
}