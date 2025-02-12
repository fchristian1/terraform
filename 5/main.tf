terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}

# random number with keepers
resource "random_integer" "random" {
  min = 10000
  max = 99999
  keepers = {
    always_same = "static_value"
  }
}


provider "azurerm" {
  skip_provider_registration = true
  features {}
}

data "external" "rg_name" {
  program = ["sh", "-c", "az group list --query '[0].name' -o tsv | jq -R '{name: .}'"]
}
data "azurerm_resource_group" "rg" {
  name = data.external.rg_name.result["name"]
}

resource "azurerm_storage_account" "staticweb" {
  name                     = "web${random_integer.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

resource "null_resource" "upload_files" {
  provisioner "local-exec" {
    command = "az storage blob upload-batch --destination '$web' --source ./website/ --account-name ${azurerm_storage_account.staticweb.name}"
  }

  depends_on = [azurerm_storage_account.staticweb]
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.staticweb.primary_web_endpoint
}
