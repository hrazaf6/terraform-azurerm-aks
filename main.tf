data "azurerm_resource_group" "this" {
  count = var.rg_create ? 0 : 1
  name  = var.rg_name
}

module "create_resource_group" {
  count       = var.rg_create ? 1 : 0
  source      = "./modules/resource_group"
  rg_name     = local.rg_name
  rg_location = var.rg_location
}

module "create_vnet" {
  count         = var.create_vnet ? 1 : 0
  source        = "./modules/network"
  inline_subnet = false
  project       = "cloudilm"
  rg_name       = var.rg_create ? module.create_resource_group.0.rg_name : data.azurerm_resource_group.this.0.name
  rg_location   = var.rg_create ? module.create_resource_group.0.rg_location : data.azurerm_resource_group.this.0.location
  vnet_name     = "aks_vnet"
  subnet_names = {
    "aks_subnet"  = "172.30.0.0/24"
    "app_gateway" = "172.30.1.0/24"
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                      = local.aks_name
  resource_group_name       = var.rg_create ? module.create_resource_group.0.rg_name : data.azurerm_resource_group.this.0.name
  location                  = var.rg_create ? module.create_resource_group.0.rg_location : data.azurerm_resource_group.this.0.location
  dns_prefix                = var.dns_prefix
  automatic_channel_upgrade = var.automatic_channel_upgrade
  dynamic "addon_profile" {
    for_each = var.enable_addon_profile ? [1] : []
    dynamic "aci_connector_linux" {
      for_each    = var.enable_aci_connector_linux ? [1] : []
      enabled     = var.enable_aci_connector_linux
      subnet_name = module.create_vnet.subnet_names.0
    }
    dynamic " azure_policy" {
      for_each = var.enable_azure_policy ? [1] : []
      enabled  = var.enable_azure_policy
    }
    dynamic "http_application_routing" {
      for_each = var.enable_http_application_routing ? [1] : []
      enabled  = var.enable_http_application_routing
    }
    dynamic "kube_dashboard" {
      for_each = var.enable_kube_dashboard ? [1] : []
      enabled  = var.enable_kube_dashboard
    }
    dynamic "oms_agent" {
      for_each                   = var.enable_oms_agent ? [1] : []
      enabled                    = var.enable_oms_agent
      log_analytics_workspace_id = var.log_analytics_workspace_id
      dynamic "oms_agent_identity" {
        for_each                  = var.enable_oms_agent_identity ? [1] : []
        client_id                 = var.client_id
        object_id                 = var.object_id
        user_assigned_identity_id = var.user_assigned_identity_id
      }
    }
  }
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  dynamic "auto_scaler_profile" {
    for_each                         = var.enable_auto_scaler_profile ? [1] : []
    balance_similar_node_groups      = var.balance_similar_node_groups
    max_graceful_termination_sec     = var.max_graceful_termination_sec
    new_pod_scale_up_delay           = var.new_pod_scale_up_delay
    scale_down_delay_after_add       = var.scale_down_delay_after_add
    scale_down_delay_after_delete    = var.scale_down_delay_after_delete
    scale_down_delay_after_failure   = var.scale_down_delay_after_failure
    scan_interval                    = var.scan_interval
    scale_down_unneeded              = var.scale_down_unneeded
    scale_down_unready               = var.scale_down_unready
    scale_down_utilization_threshold = var.scale_down_utilization_threshold
    skip_nodes_with_local_storage    = var.skip_nodes_with_local_storage
    skip_nodes_with_system_pods      = var.skip_nodes_with_system_pods
  }
  disk_encryption_set_id = var.disk_encryption_set_id
  dynamic "identity" {
    for_each                  = var.enable_identity ? [1] : []
    type                      = var.identity_type
    user_assigned_identity_id = var.user_assigned_identity_id
  }
  kubernetes_version = var.kubernetes_version
  dynamic "linux_profile" {
    for_each       = var.enable_linux_profile ? [1] : []
    admin_username = var.linux_profile_admin_username
    ssh_key {
      key_data = var.linux_profile_ssh_key_data
    }
  }
  dynamic "network_profile" {
    for_each           = var.enable_network_profile ? [1] : []
    network_plugin     = var.network_plugin
    network_mode       = var.network_mode
    network_policy     = var.network_policy
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    outbound_type      = var.outbound_type
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
    load_balancer_sku  = var.load_balancer_sku
    dynamic "load_balancer_profile" {
      for_each                  = var.enable_load_balancer_profile ? [1] : []
      outbound_ports_allocated  = var.outbound_ports_allocated
      idle_timeout_in_minutes   = var.idle_timeout_in_minutes
      managed_outbound_ip_count = var.managed_outbound_ip_count
      outbound_ip_prefix_ids    = var.outbound_ip_prefix_ids
      outbound_ip_address_ids   = var.outbound_ip_address_ids
    }
  }
  node_resource_group     = var.node_resource_group
  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id     = var.private_dns_zone_id
  dynamic "role_based_access_control" {
    for_each = var.enable_role_based_access_control ? [1] : []
    enabled  = var.enable_role_based_access_control
    azure_active_directory {
      managed                = var.managed
      tenant_id              = var.tenant_id
      admin_group_object_ids = var.managed ? var.admin_group_object_ids : null
      client_app_id          = var.managed ? null : var.client_app_id
      server_app_id          = var.managed ? null : var.server_app_id
      server_app_secret      = var.managed ? null : var.server_app_secret
    }
  }
  dynamic "service_principal" {
    for_each      = var.enable_service_principal ? [1] : []
    client_id     = var.client_id
    client_secret = var.client_secret
  }
  sku_tier = var.sku_tier
  tags = merge(
    var.additional_tags,
    {
      Name = local.aks_name
    }
  )
  dynamic "windows_profile" {
    for_each       = var.enable_dynamic_profile ? [1] : []
    admin_username = var.windows_profile_admin_username
    admin_password = var.windows_profile_admin_password
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each                     = local.node_pool_name
  name                         = each.key
  kubernetes_cluster_id        = azurerm_kubernetes_cluster.this.id
  vm_size                      = each.value.vm_size
  availability_zones           = var.availability_zones
  enable_auto_scaling          = var.enable_auto_scaling
  enable_host_encryption       = var.enable_host_encryption
  enable_node_public_ip        = var.enable_node_public_ip
  eviction_policy              = var.eviction_policy
  max_pods                     = var.max_pods
  mode                         = var.node_pool_mode
  node_labels                  = var.node_labels
  node_taints                  = var.node_taints
  orchestrator_version         = var.orchestrator_version
  os_disk_size_gb              = var.os_disk_size_gb
  os_disk_type                 = var.os_disk_type
  os_type                      = var.os_type
  priority                     = var.priority
  proximity_placement_group_id = var.proximity_placement_group_id
  spot_max_price               = var.spot_max_price
  dynamic "upgrade_settings" {
    for_each  = var.enable_upgrade_settings ? [1] : []
    max_surge = var.max_surge
  }
  vnet_subnet_id = var.create_vnet ? module.create_vnet.subnet_id.0 : var.subnet_id
  max_count      = var.enable_auto_scaling ? var.max_count : null
  min_count      = var.enable_auto_scaling ? var.min_count : null
  node_count     = var.node_count
  tags = merge(
    var.additional_tags,
    {
      Name = each.key
    }
  )
}




