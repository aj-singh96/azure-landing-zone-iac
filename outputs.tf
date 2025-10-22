# Resource Group outputs
output "resource_group_id" {
  description = "ID of the resource group"
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.name
}

# Networking outputs
output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = module.networking.subnet_ids
}

output "nsg_ids" {
  description = "Map of NSG names to their IDs"
  value       = module.networking.nsg_ids
}

# Key Vault outputs
output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.key_vault.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.key_vault_name
}


output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

# Policy outputs
output "policy_assignment_ids" {
  description = "Map of policy assignment names to IDs"
  value       = module.azure_policy.policy_assignment_ids
}

# IAM outputs
output "role_assignment_ids" {
  description = "Map of role assignment names to IDs"
  value       = module.iam.role_assignment_ids
}

# Common tags output
output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}