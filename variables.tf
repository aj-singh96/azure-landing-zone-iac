# Project configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "azure-landing-zone"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "skip_provider_registration" {
  description = "Skip provider registration (useful for limited permissions)"
  type        = bool
  default     = false
}

# Resource Group
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Networking
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name                = string
    address_prefixes    = list(string)
    service_endpoints   = optional(list(string), [])
    delegation          = optional(object({
      name                = string
      service_delegation  = object({
        name    = string
        actions = optional(list(string), [])
      })
    }))
    nsg_rules = optional(list(object({
      name                        = string
      priority                    = number
      direction                   = string
      access                      = string
      protocol                    = string
      source_port_range           = string
      destination_port_range      = string
      source_address_prefix       = string
      destination_address_prefix  = string
    }), []))
  }))
  default = {}
}

# Azure Policy
variable "enforce_tagging" {
  description = "Whether to enforce required tags policy"
  type        = bool
  default     = true
}

variable "required_tags" {
  description = "List of required tag names"
  type        = list(string)
  default     = ["Environment", "Owner", "CostCenter", "Application"]
}

variable "enforce_allowed_locations" {
  description = "Whether to enforce allowed locations policy"
  type        = bool
  default     = true
}

variable "allowed_locations" {
  description = "List of allowed Azure regions"
  type        = list(string)
  default     = ["eastus", "westus", "centralus"]
}

variable "enforce_encryption" {
  description = "Whether to enforce encryption policy"
  type        = bool
  default     = true
}

variable "enable_diagnostic_audit" {
  description = "Whether to enable diagnostic settings audit"
  type        = bool
  default     = true
}

# Key Vault
variable "key_vault_name_prefix" {
  description = "Prefix for Key Vault name (suffix will be auto-generated)"
  type        = string
  default     = "kv-lz"
}

variable "key_vault_sku" {
  description = "SKU for Key Vault"
  type        = string
  default     = "standard"
}

variable "key_vault_purge_protection" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_enable_rbac" {
  description = "Enable RBAC authorization for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_deployment" {
  description = "Allow Azure VMs to retrieve certificates from Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Allow Azure Disk Encryption to retrieve secrets from Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Allow Azure Resource Manager to retrieve secrets from Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_default_action" {
  description = "Default action for Key Vault network ACLs"
  type        = string
  default     = "Deny"
}

variable "key_vault_allowed_ips" {
  description = "List of allowed IP addresses for Key Vault access"
  type        = list(string)
  default     = []
}

variable "key_vault_allowed_subnets" {
  description = "List of subnet keys allowed to access Key Vault"
  type        = list(string)
  default     = []
}

variable "enable_key_vault_private_endpoint" {
  description = "Enable private endpoint for Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_private_endpoint_subnet" {
  description = "Subnet key for Key Vault private endpoint"
  type        = string
  default     = ""
}

variable "log_analytics_workspace_id" {
  description = "ID of Log Analytics workspace for diagnostics"
  type        = string
  default     = null
}

# IAM
variable "role_assignments" {
  description = "Map of role assignments"
  type = map(object({
    scope                           = string
    role_definition_name            = string
    principal_id                    = string
    description                     = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}
}

variable "custom_roles" {
  description = "Map of custom role definitions"
  type = map(object({
    name        = string
    scope       = string
    description = string
    permissions = object({
      actions            = optional(list(string), [])
      not_actions        = optional(list(string), [])
      data_actions       = optional(list(string), [])
      not_data_actions   = optional(list(string), [])
    })
    assignable_scopes = list(string)
  }))
  default = {}
}

variable "custom_role_assignments" {
  description = "Map of custom role assignments"
  type = map(object{
    scope                           = string
    role_definition_id              = string
    principal_id                    = string
    description                     = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  })
  default = {}
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}