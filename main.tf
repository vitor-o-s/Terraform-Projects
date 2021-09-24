# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "storageacc2"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example" {
  name               = "example"
  storage_account_id = azurerm_storage_account.example.id

  properties = {
    hello = "aGVsbG8="
  }
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "exampleworkspace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_linked_storage_account" "example" {
  data_source_type      = "customlogs"
  resource_group_name   = azurerm_resource_group.example.name
  workspace_resource_id = azurerm_log_analytics_workspace.example.id
  storage_account_ids   = [azurerm_storage_account.example.id]
}


# Para executar abra o PowerShell na azure e execute os comandos na ordem

# terraform init
# terraform plan 
# terraform apply

