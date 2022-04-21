terraform {
  backend "local" {}
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
}
