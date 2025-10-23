variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.key_vault_name))
    error_message = "Key Vault name must be 3-24 characters and contain only alphanumeric characters and hyphens"
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Key Vault (standard or premium)"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU must be either 'standard' or 'premium'"
  }
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain soft-deleted items"
  type        = number
  default     = 90
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90"
  }
}

variable "purge_protection_enabled" {
  description = "Whether to enable purge protection"
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  description = "Allow Azure Virtual Machines to retrieve certificates"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Allow Azure Disk Encryption to retrieve secrets"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Allow Azure Resource Manager to retrieve secrets"
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Use RBAC for authorization instead of access policies"
  type        = bool
  default     = true
}

variable "network_acls" {
  description = "Network ACLs for the Key Vault"
  type = object({
    bypass                   = string
    default_action           = string
    ip_rules                 = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = {
    bypass                   = "AzureServices"
    default_action           = "Deny"
    ip_rules                 = []
    virtual_network_subnet_ids = []
  }
}

variable "access_policies" {
  description = "Map of access policies (only used if RBAC is disabled)"
  type = map(object({
    object_id              = string
    key_permissions        = optional(list(string), [])
    secret_permissions     = optional(list(string), [])
    certificate_permissions= optional(list(string), [])
    storage_permissions    = optional(list(string), [])
  }))
  default = {}
}

variable "log_analytics_workspace_id" {
  description = "ID of Log Analytics workspace for diagnostics"
  type        = string
  default     = null
}

variable "enable_private_endpoint" {
  description = "Whether to create a private endpoint"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}