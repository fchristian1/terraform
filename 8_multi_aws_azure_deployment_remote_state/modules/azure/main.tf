resource "random_integer" "random" {
  min = 10000
  max = 99999
  keepers = {
    always_same = "static_value"
  }
}
provider "azurerm" {
  subscription_id = data.external.sub_id.result["id"]
  features {}
}

# Azure storage account with blob container

resource "azurerm_storage_account" "myblob" {
  name                     = "myblob${random_integer.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "myblob" {
  name                  = "myblob"
  storage_account_id    = azurerm_storage_account.myblob.id
  container_access_type = "private"
}
