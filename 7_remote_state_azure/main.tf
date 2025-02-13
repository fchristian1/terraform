resource "random_integer" "random" {
  min = 10000
  max = 99999
  keepers = {
    always_same = "static_value"
  }
}
data "external" "rg_name" {
  program = ["sh", "-c", "az group list --query '[0].name' -o tsv | jq -R '{name: .}'"]
}

data "external" "sub_id" {
  program = ["sh", "-c", "az account show --query 'id' -o tsv | jq -R '{id: .}'"]
}


data "azurerm_resource_group" "rg" {
  name = data.external.rg_name.result["name"]
}

provider "azurerm" {
  subscription_id = data.external.sub_id.result["id"]
  features {}
}

# resources to save the state file in Azure Storage Account and Table
resource "azurerm_storage_account" "terraform_state" {
  name                     = "terraformstate${random_integer.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_table" "terraform_locks" {
  name                 = "terraformlocks"
  storage_account_name = azurerm_storage_account.terraform_state.name
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraform-state"
  storage_account_id    = azurerm_storage_account.terraform_state.id
  container_access_type = "private"
}
