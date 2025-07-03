variable "rg_readers" {
  description = "List of user principal names with Reader access to the resource group"
  type = set(string)
}

variable "team" {
  description = "Team name for the resource group"
  type = string
  default = "sre"
}

variable "project" {
  description = "Project name for the resource group"
  type = string
  default = "challenge"
  
}

variable "company" {
  description = "Company name for the resource group"
  type = string
  default = "flaschenpost"
  
}

variable "location" {
  description = "Azure region for the resource group"
  type = string
  default = "westeurope"
  
}

variable "stg_owners" {
  description = "List of owners for the storage account"
  type = set(string)
}

variable "address_space" {
  description = "Address space for the virtual network"
  type = list(string)
  default = ["10.0.0.0/24"]

}

variable "dns_servers" {
  description = "DNS servers for the virtual network"
  type = list(string)
  default = ["10.0.0.4", "10.0.0.5"]

}

variable "address_prefixes" {
  description = "Address prefixes for the subnet"
  type = list(string)
  default = ["10.0.0.0/27"]

}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  
}