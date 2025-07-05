##### Query azure to get the storage account diagnostic categories #####
# This is necessary to dynamically enable all diagnostic logs and metrics for the storage account, instead of hardcoding them.
data "azurerm_monitor_diagnostic_categories" "storage" {
  resource_id = var.stg_id
}

##### Creation of Log Analytics Workspace, for the storage of diagnostic logs and metrics #####
resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = local.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days

  tags = {
    department = var.department
  }
  
}

##### Creation of Diagnostic Setting for the Storage Account #####
# This will enable the collection of logs and metrics from the storage account to the Log Analytics Workspace, dynamically based on the categories retrieved from the `azurerm_monitor_diagnostic_categories` data source.
# The `log_analytics_destination_type` is set to "Dedicated" to ensure that logs are stored in different tables in the Log Analytics Workspace, instead of the "AzureDiagnostics" table.
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
    }
}

  dynamic "metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.storage.metrics)
    content {
      category = metric.value
      enabled = true
    }
  }
  
}
