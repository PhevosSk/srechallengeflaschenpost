##### Resource Group

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags = {
    department = "SRE"
  }
}

#### Storage Account
resource "azurerm_storage_account" "stg" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  tags = {
    department = "SRE"
  }
}

#### Storage Container
resource "azurerm_storage_container" "container" {
  name                  = local.container_name
  storage_account_name  = var.storage_account_name 
  container_access_type = "private"
}

#### Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name = local.vnet_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = var.address_space
  dns_servers = var.dns_servers

    tags = {
        department = "SRE"
    }
}

resource "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes

}

##### Private Endpoint and DNS Configuration for Storage Account
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  name                  = local.azurerm_private_dns_zone_virtual_network_link
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "pve" {
  name = local.private_endpoint_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id = azurerm_subnet.subnet.id

  private_service_connection {
    name = local.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.stg.id
    is_manual_connection = false
    subresource_names = ["blob"]
  }

  private_dns_zone_group {
    name = local.private_dns_zone_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
  }

}


#### Role Assignments for Storage Account and Resource Group
data "azuread_user" "rg_readers" {
  for_each = toset(var.rg_readers)
  user_principal_name = each.key
}

data "azuread_user" "stg_owners" {
  for_each = toset(var.stg_owners)
  user_principal_name = each.key
}


resource "azurerm_role_assignment" "rg_system_owner" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id
  
}


resource "azurerm_role_assignment" "rg_readers" {
  for_each             = data.azuread_user.rg_readers
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = each.value.object_id
  
}

resource "azurerm_role_assignment" "stg_owners" {
  for_each            = data.azuread_user.stg_owners
  scope               = azurerm_resource_group.rg.id
  role_definition_name = "Owner"
  principal_id        = each.value.object_id
  
}