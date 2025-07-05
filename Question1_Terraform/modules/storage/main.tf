#data "azurerm_client_config" "current" {}

##### Resource Group #####
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags = {
    department = var.department
  }
}

#### Storage Account #####
resource "azurerm_storage_account" "stg" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier

  # Force all access through private endpoint
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  tags = {
    department = var.department
  }
}

#### Storage Container #####
resource "azurerm_storage_container" "container" {
  name                  = local.container_name
  storage_account_name  = azurerm_storage_account.stg.name
  container_access_type = "private"
}


### Securing the Storage Account with Private Endpoint #####
#### Virtual Network #####
resource "azurerm_virtual_network" "vnet" {
  name = local.vnet_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = var.address_space
  dns_servers = var.dns_servers

  tags = {
      department   = var.department
    }
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes

}

##### Private Endpoint and DNS Configuration for Storage Account #####
# Creates a private DNS zone for Azure Blob Storage to resolve private endpoint IP addresses
# Enables secure name resolution within the virtual network for privatelink.blob.core.windows.net
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name 
}

# Links the private DNS zone to the virtual network for automatic DNS resolution
# Allows Other Services in the VNet to resolve the storage account's private endpoint IP address
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  name                  = local.azurerm_private_dns_zone_virtual_network_link
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# Creates a private endpoint for the storage account to enable secure access from within the VNet
# Eliminates internet traffic by providing a private IP address for blob storage access
resource "azurerm_private_endpoint" "pve" {
  name                  = local.private_endpoint_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  subnet_id             = azurerm_subnet.subnet.id

  private_service_connection {
    name                            = local.private_service_connection_name
    private_connection_resource_id  = azurerm_storage_account.stg.id
    is_manual_connection            = false
    subresource_names               = ["blob"]
  }

  private_dns_zone_group {
    name                    = local.private_dns_zone_group_name
    private_dns_zone_ids    = [azurerm_private_dns_zone.private_dns_zone.id]
  }

}


##### Role Assignments for Storage Account and Resource Group #####
resource "azurerm_role_assignment" "rg_system_owner" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id         = local.mock_client_config.tenant_id
}


resource "azurerm_role_assignment" "rg_readers" {
  for_each             = var.rg_readers
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = local.mock_rg_readers[each.key]

}

resource "azurerm_role_assignment" "stg_owners" {
  for_each               = var.stg_owners
  scope                  = azurerm_resource_group.rg.id
  role_definition_name   = "Owner"
  principal_id           = local.mock_stg_owners[each.key]
}