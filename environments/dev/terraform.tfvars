# Dev environment configuration

project_name= "azure-landing-zone"
environment              = "dev"
location                 = "eastus"

resource_group_name      = "rg-landingzone-dev-001"

vnet_name                = "vnet-landingzone-dev-001"
vnet_address_space       = ["10.10.0.0/16"]

subnets = {
  frontend = {
    name               = "snet-frontend-dev"
    address_prefixes   = ["10.10.1.0/24"]
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
    name               = "snet-backend-dev"
    address_prefixes   = ["10.10.2.0/24"]
    service_endpoints  = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
    nsg_rules          = []
  }
}

key_vault_name_prefix          = "kv-lz-dev"
key_vault_purge_protection     = false   # Relaxed for dev
enable_key_vault_private_endpoint = false
key_vault_allowed_subnets      = ["backend"]

enforce_tagging                = false   # Relaxed for dev
enforce_allowed_locations      = true
enforce_encryption             = true

tags = {
  Owner          = "DevOps Team"
  CostCenter     = "IT-Dev"
  Application    = "Landing Zone"
  Purpose.       = "Development"
}