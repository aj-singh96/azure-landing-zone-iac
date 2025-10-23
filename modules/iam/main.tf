resource "azurerm_role_assignment" "this" {
  for_each            = var.role_assignments

  scope               = each.value.scope
  role_definition_name= each.value.role_definition_name
  principal_id        = each.value.principal_id
  description         = lookup(each.value, "description", null)

  # Skip if role definition ID is provided instead
  skip_service_principal_aad_check = lookup(each.value, "skip_service_principal_aad_check", false)
}

resource "azurerm_role_assignment" "custom" {
  for_each            = var.custom_role_assignments

  scope               = each.value.scope
  role_definition_id  = each.value.role_definition_id
  principal_id        = each.value.principal_id
  description         = lookup(each.value, "description", null)

  skip_service_principal_aad_check = lookup(each.value, "skip_service_principal_aad_check", false)
}

# Custom role definition
resource "azurerm_role_definition" "custom_roles" {
  for_each            = var.custom_roles

  name                = each.value.name
  scope               = each.value.scope
  description         = each.value.description

  permissions = [{
    actions          = lookup(each.value.permissions, "actions", [])
    not_actions      = lookup(each.value.permissions, "not_actions", [])
    data_actions     = lookup(each.value.permissions, "data_actions", [])
    not_data_actions = lookup(each.value.permissions, "not_data_actions", [])
  }]

  assignable_scopes   = each.value.assignable_scopes
}

# Common role assignments for landing zone
locals {
  common_roles = {
    "reader" = {
      name        = "Reader"
      description = "View all resources, but does not allow you to make any changes"
    }
    "contributor" = {
      name        = "Contributor"
      description = "Grants full access to manage all resources, but does not allow you to assign roles in Azure RBAC"
    }
    "owner" = {
      name        = "Owner"
      description = "Grants full access to manage all resources, including the ability to assign roles in Azure RBAC"
    }
    "key_vault_administrator" = {
      name        = "Key Vault Administrator"
      description = "Perform all data plane operations on a key vault and all objects in it"
    }
    "key_vault_secrets_user" = {
      name        = "Key Vault Secrets User"
      description = "Read secret contents"
    }
    "network_contributor" = {
      name        = "Network Contributor"
      description = "Lets you manage networks, but not access to them"
    }
    "security_admin" = {
      name        = "Security Admin"
      description = "View and update permissions for Security Center"
    }
  }
}