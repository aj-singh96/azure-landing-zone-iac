# Production Environment configuration

project_name = "azure-landing-zone"
environment              = "prod"
location                 = "eastus"

resource_group_name      = "rg-landingzone-prod-001"

vnet_name                = "vnet-landingzone-prod-001"
vnet_address_space       = ["10.0.0.0/16"]

subnets = {
  frontend = {
    name               = "snet-frontend-prod"
    address_prefixes   = ["10.0.1.0/24"]
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
      },
      {
        name                     = "AllowHTTP"
        priority                 = 110
        direction                = "Inbound"
        access                   = "Allow"
        protocol                 = "Tcp"
        source_port_range        = "*"
        destination_port_range   = "80"
        source_address_prefix    = "Internet"
        destination_address_prefix = "*"
      }
    ]
  }
  backend = {
    name               = "snet-backend-prod"
    address_prefixes   = ["10.0.2.0/24"]
    service_endpoints  = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
    nsg_rules          = [
      {
        name                     = "AllowFrontend"
        priority                 = 100
        direction                = "Inbound"
        access                   = "Allow"
        protocol                 = "Tcp"
        source_port_range        = "*"
        destination_port_range   = "*"
        source_address_prefix    = "10.0.1.0/24"
        destination_address_prefix = "*"
      },
      {
        name                     = "AllowManagement"
        priority                 = 110
        direction                = "Inbound"
        access                   = "Allow"
        protocol                 = "Tcp"
        source_port_range        = "*"
        destination_port_range   = "443"
        source_address_prefix    = "10.0.3.0/24"
        destination_address_prefix = "*"
      }
    ]
  }
  management = {
    name               = "snet-management-prod"
    address_prefixes   = ["10.0.3.0/24"]
    service_endpoints  = ["Microsoft.KeyVault"]
    nsg_rules          = []
  }
  database = {
    name               = "snet-database-prod"
    address_prefixes   = ["10.0.4.0/24"]
    service_endpoints  = ["Microsoft.Sql", "Microsoft.Storage"]
    nsg_rules = [
      {
        name                     = "AllowBackend"
        priority                 = 100
        direction                = "Inbound"
        access                   = "Allow"
        protocol                 = "Tcp"
        source_port_range        = "*"
        destination_port_range   = "1433"
        source_address_prefix    = "10.0.2.0/24"
        destination_address_prefix = "*"
      }
    ]
  }
}

key_vault_name_prefix           = "kv-lz-prod"
key_vault_purge_protection      = true
enable_key_vault_private_endpoint = true
key_vault_private_endpoint_subnet = "management"
key_vault_allowed_subnets       = ["backend", "management", "database"]

enforce_tagging                 = true
required_tags                   = ["Environment", "Owner", "CostCenter", "Application", "DataClassification"]
enforce_allowed_locations       = true
allowed_locations               = ["eastus", "westus"]
enforce_encryption              = true
enable_diagnostic_audit         = true

tags = {
  Owner             = "DevOps Team"
  CostCenter        = "IT-PROD"
  Application       = "Landing Zone"
  Purpose           = "Production Workloads"
  DataClassification= "Confidential"
  Compliance        = "SOC2"
}