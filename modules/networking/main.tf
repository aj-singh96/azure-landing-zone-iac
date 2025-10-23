resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each            = var.subnets

  name                = each.value.name
  resource_group_name = var.resource_group_name
  virtual_network_name= azurerm_virtual_network.this.name
  address_prefixes    = each.value.address_prefixes

  # Enable service endpoints if specified
  service_endpoints = lookup(each.value, "service_endpoints", [])

  # Delegate subnet if specified
  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = lookup(delegation.value.service_delegation, "actions", [])
      }
    }
  }
}

resource "azurerm_network_security_group" "nsgs" {
  for_each            = var.subnets

  name                = "${each.value.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "default_deny_inbound" {
  for_each = var.subnets

  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[each.key].name
}

resource "azurerm_network_security_rule" "custom_rules" {
  for_each = {
    for rule in local.all_nsg_rules : "${rule.subnet_key}-${rule.name}" => rule
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[each.value.subnet_key].name
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}

locals {
  all_nsg_rules = flatten([
    for subnet_key, subnet in var.subnets : [
      for rule in lookup(subnet, "nsg_rules", []) : merge(rule, {
        subnet_key = subnet_key
      })
    ]
  ])
}