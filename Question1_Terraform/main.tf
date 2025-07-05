module "storage" {
  source                        = "./modules/storage"
  department                    = var.department
  project                       = var.project
  company                       = var.company
  stg_owners                    = var.stg_owners
  rg_readers                    = var.rg_readers
  dns_servers                   = var.dns_servers
  address_prefixes              = var.address_prefixes
  location                      = var.location
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  access_tier                   = var.access_tier

}

module "observability" {
  source                        = "./modules/observability"
  department                    = var.department
  project                       = var.project
  company                       = var.company
  stg_id                        = module.storage.stg_id
  resource_group_name           = module.storage.resource_group_name
  location                      = var.location

}