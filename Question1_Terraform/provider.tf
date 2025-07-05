terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 3.0"
        }
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 2.0"
        }
    }
    
    required_version = ">= 1.0"
}

provider "azurerm" {
    features {}
}

provider "azuread" {
    # The AzureAD provider does not require any specific configuration
    # It will use the credentials from the environment or the Azure CLI
}