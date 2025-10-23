variable "role_assignments" {
  description = "Map of role assignments using built-in role names"
  type = map(object({
    scope                         = string
    role_definition_name          = string
    principal_id                  = string
    description                   = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}
}

variable "custom_role_assignments" {
  description = "Map of role assignments using custom role definition IDs"
  type = map(object({
    scope                         = string
    role_definition_id            = string
    principal_id                  = string
    description                   = optional(string)
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}
}

variable "custom_roles" {
  description = "Map of custom role definitions to create"
  type = map(object({
    name                         = string
    scope                        = string
    description                  = string
    permissions                  = object({
      actions          = optional(list(string), [])
      not_actions      = optional(list(string), [])
      data_actions     = optional(list(string), [])
      not_data_actions = optional(list(string), [])
    })
    assignable_scopes            = list(string)
  }))
  default = {}
}