output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "stg_id" {
  value = azurerm_storage_account.stg.id

}

output "stg_primary_access_key" {
  value = azurerm_storage_account.stg.primary_access_key

}

output "stg_primary_connection_string" {
  value = azurerm_storage_account.stg.primary_connection_string

}

output "container_id" {
  value = azurerm_storage_container.container.id

}