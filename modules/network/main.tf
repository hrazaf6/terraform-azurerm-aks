data "azurerm_resource_group" "this" {
  count = var.rg_create ? 0 : 1
  name     = var.rg_name
}

module "create_resource_group" {
  count    = var.rg_create ? 1 : 0
  source      = "../resource_group"
  rg_name     = local.rg_name
  rg_location = var.rg_location
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.rg_create ? module.create_resource_group.0.rg_location : data.azurerm_resource_group.this.0.location
  resource_group_name = var.rg_create ? module.create_resource_group.0.rg_name : data.azurerm_resource_group.this.0.name
  address_space       = var.vnet_address_space 
  bgp_community       = var.bgp_community
  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection_plan ? [1] : []
    content {
      id       = var.ddos_id
      enable   = var.enable_ddos_protection_plan
    }
  }
  dns_servers = var.dns_servers
  dynamic "subnet" {
    for_each       = var.inline_subnet ? local.subnet_names : {}
    content {
      name           = subnet.key
      address_prefix = subnet.value
    }
  }
  vm_protection_enabled = var.vm_protection_enabled
  tags = merge(
    var.additional_tags, {
      Name = var.vnet_name
    }
  )
}

resource "azurerm_subnet" "this" {
  for_each = var.inline_subnet ? {} : local.subnet_names
  name = each.key
  resource_group_name = var.rg_create ? module.create_resource_group.0.rg_name : data.azurerm_resource_group.this.0.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [each.value]
  dynamic "delegation" {
    for_each = var.enable_delegation ? [1] : []
    content {
      name = var.delegation_name
      service_delegation {
        name = var.name_of_service_delegation
        actions = var.service_delegation_actions
      }
    }
  }
  enforce_private_link_endpoint_network_policies = var.enable_enforce_private_link_endpoint_network_policies
  enforce_private_link_service_network_policies = var.enable_enforce_private_link_service_network_policies
  service_endpoints = var.service_endpoints
  service_endpoint_policy_ids = var.service_endpoint_policy_ids
}
