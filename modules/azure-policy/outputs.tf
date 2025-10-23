output "policy_assignment_ids" {
  description = "Map of policy assignment names to their IDs"
  value = merge(
    var.enforce_tagging ? { "require_tags" = azurerm_resource_group_policy_assignment.require_tags[0].id } : {},
    var.enforce_allowed_locations ? { "allowed_locations" = azurerm_resource_group_policy_assignment.allowed_locations[0].id } : {},
    var.enforce_encryption ? { "require_encryption" = azurerm_resource_group_policy_assignment.require_encryption[0].id } : {},
    var.enable_diagnostic_audit ? { "audit_diagnostic_settings" = azurerm_resource_group_policy_assignment.audit_diagnostic_settings[0].id } : {},
    var.enforce_naming_convention ? { "naming_convention" = azurerm_resource_group_policy_assignment.naming_convention[0].id } : {}
  )
}

output "custom_policy_definition_ids" {
  description = "IDs of custom policy definitions"
  value = var.enforce_naming_convention ? {
    "naming_convention" = azurerm_policy_definition.naming_convention[0].id
  } : {}
}