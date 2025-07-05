locals {
  resource_group_name = "${var.department}-${var.project}-${var.company}"
  container_name = var.department
  storage_account_name = "${var.department}${var.project}${var.company}"
}


locals {
  azurerm_private_dns_zone_virtual_network_link = "pvt-dns-zone-link-${var.department}-${var.project}-${var.company}"
  private_endpoint_name = "pvt-endpoint-${var.department}-${var.project}-${var.company}"
  private_service_connection_name = "pvt-svc-conn-${var.department}-${var.project}-${var.company}"
  private_dns_zone_group_name = "pvt-dns-zone-group-${var.department}-${var.project}-${var.company}"
}

locals {
  vnet_name             = "vnet-${var.department}-${var.project}-${var.company}"
  subnet_name           = "sub-${var.department}-${var.project}-${var.company}"
}

locals {
  mock_rg_readers = {
    "foivos@demo.com" = "00000000-0000-0000-0000-000000000001"
    "denis@demo.com"   = "00000000-0000-0000-0000-000000000002"
    "olga@demo.com" = "00000000-0000-0000-0000-000000000003"
  }
}

locals {
  mock_stg_owners = {
    "foivos@demo.com" = "00000000-0000-0000-0000-000000000001"
  }
}

locals {
  mock_client_config = {
    tenant_id       = "00000000-0000-0000-0000-000000000000"
    client_id       = "00000000-0000-0000-0000-000000000000"
    subscription_id = "00000000-0000-0000-0000-000000000000"
  }
}
