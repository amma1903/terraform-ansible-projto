terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id            = var.azure_subscription_id
  tenant_id                  = var.arm_tenant_id
  skip_provider_registration = true
}

/**
resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}
**/

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstatemc1yh"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "blob"
}