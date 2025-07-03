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
  description = "Owners of the storage account"
  type = set(string)
  default = []
  
}

variable "rg_readers" {
  description = "Readers of the resource group"
  type = set(string)
  default = []
  
}

variable "address_space" {
  description = "Address space for the virtual network"
  type = list(string)
  
}

variable "dns_servers" {
  description = "DNS servers for the virtual network"
  type = list(string)
  
}

variable "address_prefixes" {
  description = "Address prefixes for the subnet"
  type = list(string)
  
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string

}