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


variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}


variable "retention_days" {
  description = "Retention days for the logs and metrics"
  type        = number
  default     = 30
}

variable "stg_id" {
  description = "ID of the Storage Account of the Storage Account to monitor"
  type        = string
}