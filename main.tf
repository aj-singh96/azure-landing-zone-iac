data "azurerm_client_config" "current" {}

# Generate unique suffix for resources requiring global uniqueness
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Core resource group
module "resource_group" {
  source = "./modules/resource-group"

  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Networking infrastructure
module "networking" {
  source = "./modules/networking"

  vnet_name          = var.vnet_name
  resource_group_name = module.resource_group.name
  location           = var.location
  address_space      = var.vnet_address_space

  subnets = var.subnets

  tags = local.common_tags
}

# Azure Policy assignments
module "azure_policy" {
  source = "./modules/azure-policy"

  resource_group_id   = module.resource_group.id
  resource_group_name = module.resource_group.name

  enforce_tagging         = var.enforce_tagging
  required_tags           = var.required_tags
  enforce_allowed_locations = var.enforce_allowed_locations
  allowed_locations       = var.allowed_locations
  enforce_encryption      = var.enforce_encryption
}

# Key Vault
module "key_vault" {
  source = "./modules/key-vault"

  key_vault_name                = "${var.key_vault_name_prefix}-${random_string.suffix.result}"
  resource_group_name           = module.resource_group.name
  location                      = var.location

  sku_name                      = var.key_vault_sku
  purge_protection_enabled      = var.key_vault_purge_protection
  enable_rbac_authorization     = var.key_vault_enable_rbac
  enabled_for_deployment        = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption   = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment

  network_acls = {
    bypass         = "AzureServices"
    default_action = var.key_vault_default_action
    ip_rules       = var.key_vault_allowed_ips
    virtual_network_subnet_ids = [
      for k, v in module.networking.subnet_ids : v if contains(var.key_vault_allowed_subnets, k)
    ]
  }

  enable_private_endpoint      = var.enable_key_vault_private_endpoint
  private_endpoint_subnet_id   = var.enable_key_vault_private_endpoint ? module.networking.subnet_ids[var.key_vault_private_endpoint_subnet] : null
  key_vault_private_endpoint_subnet = null
  log_analytics_workspace_id   = var.log_analytics_workspace_id

  tags = local.common_tags
}

# IAM role assignments
module "iam" {
  source = "./modules/iam"

  role_assignments            = var.role_assignments

  custom_roles                = var.custom_roles
  custom_role_assignments     = var.custom_role_assignments
}

# Local variables
locals {
  common_tags = merge (
    