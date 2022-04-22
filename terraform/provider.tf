terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate_RG"
    storage_account_name = "tfstate14394"
    container_name       = "tfstate-fuckbudget"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.0.2"
    }
    archive = {
      source = "hashicorp/archive"
      version = "~> 2.2.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.1.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "9f74b8e4-4971-43b8-9375-a0e0a633af3a"
}
