
data "azurerm_monitor_diagnostic_categories" "storage" {
  resource_id = var.stg_id
}


resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"

  retention_in_days = 30

  tags = {
    team   = var.team
  }
  
}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name                       = local.monitor_diagnostic_setting
  target_resource_id         = var.stg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  log_analytics_destination_type = "Dedicated"

    dynamic "log"{
      for_each = toset(data.azurerm_monitor_diagnostic_categories.storage.log_category_types )
      content {
        category = log.value
        enabled = true

      retention_policy{
        enabled = true
        days = var.retention_days
      }
    }
}

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.storage.metrics)
    content {
      category = metric.value
      enabled = true
      
      retention_policy {
        enabled = true
        days = var.retention_days
      }
    }
  }
  
}
