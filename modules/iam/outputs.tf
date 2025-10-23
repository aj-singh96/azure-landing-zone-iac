output "role_assignment_ids" {
  description = "Map of role assignment names to their IDs"
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}

output "custom_role_assignment_ids" {
  description = "Map of custom role assignment names to their IDs"
  value       = { for k, v in azurerm_role_assignment.custom : k => v.id }
}

output "custom_role_definition_ids" {
  description = "Map of custom role definition names to their IDs"
  value       = { for k, v in azurerm_role_definition.custom_roles : k => v.id }
}

output "custom_role_definition_names" {
  description = "Map of custom role definition keys to their names"
  value       = { for k, v in azurerm_role_definition.custom_roles : k => v.name }
}

output "common_role_definitions" {
  description = "Map of common Azure built-in role definitions"
  value       = local.common_roles
}