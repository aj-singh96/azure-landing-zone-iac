# Staging Environment Configuration
project_name           = "azure-landing-zone"
environment            = "staging"
location               = "eastus"

resource_group_name    = "rg-landingzone-staging-001"

vnet_name              = "vnet-landingzone-staging-001"
vnet_address_space     = ["10.20.0.0/16"]

subnets = {
  frontend = {
    name               = "snet-frontend-staging"
    address_prefixes   = ["10.20.1.0/24"]
    service_endpoints  = ["Microsoft.KeyVault", "Microsoft.Storage"]
    nsg_rules = [
      {
        name                     = "AllowHTTPS"
        priority                 = 100
        direction                = "Inbound"
        access                   = "Allow"
        protocol                 = "Tcp"
        source_port_range        = "*"
        destination_port_range   = "443"
        source_address_prefix    = "Internet"
        destination_address_prefix = "*"
      }
    ]
  }
  backend = {
    name               = "snet-backend-staging"
    address_prefixes   = ["10.20.2.0/24"]
    service_endpoints  = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
    nsg_rules = [
      {
        name                     = "AllowFrontend"
        priority                 = 100
        direction                = "Inbound"
        access                   = "Allow"
        protocol                 = "Tcp"
        source_port_range        = "*"
        destination_port_range   = "*"
        source_address_prefix    = "10.20.1.0/24"
        destination_address_prefix = "*"
      }
    ]
  }
 management = {
    name               = "snet-management-staging"
    address_prefixes   = ["10.20.3.0/24"]
    service_endpoints  = ["Microsoft.KeyVault"]
    nsg_rules          = []
  }
}

key_vault_name_prefix           = "kv-lz-staging"
key_vault_purge_protection      = true
enable_key_vault_private_endpoint = true
key_vault_private_endpoint_subnet = "backend"
key_vault_allowed_subnets       = ["backend", "management"]

enforce_tagging                 = true
enforce_allowed_locations       = true
enforce_encryption              = true
enable_diagnostic_audit         = true

tags = {
  Owner        = "DevOps Team"
  CostCenter   = "IT-STAGING"
  Application  = "Landing Zone"
  Purpose      = "Pre-Production Testing"
}