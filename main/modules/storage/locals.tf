locals {
  resource_group_name = "${var.team}-${var.project}-${var.company}"
  location = "westeurope"
  container_name = var.team
}


locals {
  azurerm_private_dns_zone_virtual_network_link = "pvt-dns-zone-link-${var.team}-${var.project}-${var.company}"
  private_endpoint_name = "pvt-endpoint-${var.team}-${var.project}-${var.company}"
  private_service_connection_name = "pvt-svc-conn-${var.team}-${var.project}-${var.company}"
  private_dns_zone_group_name = "pvt-dns-zone-group-${var.team}-${var.project}-${var.company}"
}

locals {
  vnet_name             = "vnet-${var.team}-${var.project}-${var.company}"
  subnet_name           = "sub-${var.team}-${var.project}-${var.company}"
}