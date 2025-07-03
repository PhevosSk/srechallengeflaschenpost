module "storage" {
  source              = "./modules/storage"
  team                = var.team
  project             = var.project
  company             = var.company
  stg_owners          = var.stg_owners
  rg_readers          = var.rg_readers
  dns_servers         = var.dns_servers
  address_prefixes    = var.address_prefixes
  storage_account_name = var.storage_account_name
  log_analytics_workspace_name = var.log_analytics_workspace_name

}

module "observability" {
  source                        = "./modules/observability"
  team                          = var.team
  project                       = var.project
  company                       = var.company
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  storage_account_name          = var.storage_account_name
  stg_id                        = module.storage.stg_id
  resource_group_name           = module.storage.resource_group_name

}