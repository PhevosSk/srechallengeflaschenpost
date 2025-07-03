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

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  
}


variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  
}

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "westeurope"
  
}

variable "retention_days" {
  description = "Retention days for the logs and metrics"
  type        = number
  default     = 30
}

variable "stg_id" {
  description = "ID of the Storage Account from the Storage module"
  type        = string
  
}