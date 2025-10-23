data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled
  enabled_for_deployment      = var.enabled_for_deployment
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization   = var.enable_rbac_authorization

  network_acls {
    bypass                     = var.network_acls.bypass
    default_action             = var.network_acls.default_action
    ip_rules                   = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }

  tags = var.tags
}

# Access policies (only if RBAC is not enabled)
resource "azurerm_key_vault_access_policy" "policies" {
  for_each = var.enable_rbac_authorization ? {} : var.access_policies

  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.value.object_id

  key_permissions         = lookup(each.value, "key_permissions", [])
  secret_permissions      = lookup(each.value, "secret_permissions", [])
  certificate_permissions = lookup(each.value, "certificate_permissions", [])
  storage_permissions     = lookup(each.value, "storage_permissions", [])
}

# Diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name               = "diag-${var.key_vault_name}"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Private endpoint (optional)
resource "azurerm_private_endpoint" "key_vault" {
  count               = var.enable_private_endpoint ? 1 : 0

  name                = "pe-${var.key_vault_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${var.key_vault_name}"
    private_connection_resource_id  = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags
}