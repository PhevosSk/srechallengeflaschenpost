variable "department" {
  description = "Department name"
  type = string
  default = "sre"
}

variable "project" {
  description = "Project name"
  type = string
  default = "challenge"
}

variable "company" {
  description = "Company name"
  type = string
  default = "flaschenpost"
}

variable "location" {
  description = "Azure region"
  type = string
  default = "westeurope"
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

variable "rg_readers" {
  description = "List of user principal names with Reader Role to the resource group"
  type = set(string)
  default = [
    "foivos@demo.com",
    "denis@demo.com",
    "olga@demo.com"
  ]
}

variable "stg_owners" {
  description = "List of user principals with Owner Role to the storage account"
  type = set(string)
  default = [
    "foivos@demo.com"
  ]
}

variable "access_tier" {
  description = "Access tier for the storage account"
  type = string  
}

variable "account_tier" {
  description = "Account tier for the storage account"
  type = string
  default = "Standard"
}

variable "account_replication_type" {
  description = "Account replication type for the storage account"
  type = string
  default = "LRS"
}