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
