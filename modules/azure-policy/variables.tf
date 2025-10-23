variable "resource_group_id" {
  description = "ID of the resource group to apply policies to"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group (used in policy assignment names)"
  type        = string
}

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

variable "enforce_naming_convention" {
  description = "Whether to enforce naming convention policy"
  type        = bool
  default     = false
}

variable "naming_convention_pattern" {
  description = "Regex pattern for resource naming convention"
  type        = string
  default     = "rg-*-*-*###"
}