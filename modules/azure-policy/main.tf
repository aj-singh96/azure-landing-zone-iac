# Azure policy assignments
resource "azurerm_resource_group_policy_assignment" "require_tags" {
  count                = var.enforce_tagging ? 1 : 0
  name                 = "require-tags-${var.resource_group_name}"
  resource_group_id    = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670de1-8a4d-4649-9c89-2d3abc0a5025"
  display_name         = "Require tags on resource group"
  description          = "Enforces existence of required tags"

  parameters = jsonencode({
    tagNames = {
      value = var.required_tags
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  count                = var.enforce_allowed_locations ? 1 : 0
  name                 = "allowed-locations-${var.resource_group_name}"
  resource_group_id    = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  display_name         = "Allowed locations for resources"
  description          = "Restricts the locations where resources can be deployed"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "require_encryption" {
  count                = var.enforce_encryption ? 1 : 0
  name                 = "require-encryption-${var.resource_group_name}"
  resource_group_id    = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/096103e3-50aa-4549-abde-af6a3f72724d"
  display_name         = "Require encryption for storage accounts"
  description          = "Ensures storage accounts have encryption enabled"
}

resource "azurerm_resource_group_policy_assignment" "audit_diagnostic_settings" {
  count                = var.enable_diagnostic_audit ? 1 : 0
  name                 = "audit-diagnostics-${var.resource_group_name}"
  resource_group_id    = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7ff891eb-503c-429a-8828-af049802c1d9"
  display_name         = "Audit diagnostic settings"
  description          = "Audits resources without diagnostic settings enabled"
}

# Custom policy definition for naming convention
resource "azurerm_policy_definition" "naming_convention" {
  count                = var.enforce_naming_convention ? 1 : 0
  name                 = "naming-convention-policy"
  policy_type          = "Custom"
  mode                 = "All"
  display_name         = "Enforce naming convention"
  description          = "Enforces resource naming convention based on defined pattern"

  metadata = jsonencode({
    category = "General"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field = "type"
          equals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          field = "name"
          notMatch = var.naming_convention_pattern
        }
      ]
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "naming_convention" {
  count                = var.enforce_naming_convention ? 1 : 0
  name                 = "naming-convention-${var.resource_group_name}"
  resource_group_id    = var.resource_group_id
  policy_definition_id = azurerm_policy_definition.naming_convention[0].id
  display_name         = "Enforce naming convention"
  description          = "Enforces organizational naming standards"
}