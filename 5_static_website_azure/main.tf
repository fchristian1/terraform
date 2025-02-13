terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.18.0"
    }
  }
}

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
resource "azurerm_storage_account" "staticweb" {
  name                     = "web${random_integer.random.result}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"


}


resource "azurerm_storage_account_static_website" "staticwebsite" {
  storage_account_id = azurerm_storage_account.staticweb.id
  index_document     = "index.html"
  error_404_document = "404.html"
}
# This local block defines the MIME types for the files in the website directory.
locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}
resource "azurerm_storage_blob" "files" {
  for_each = fileset("./website", "**/*")

  name                   = each.value
  storage_account_name   = azurerm_storage_account.staticweb.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "./website/${each.value}"
  content_type           = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
  content_md5            = filemd5("./website/${each.value}")


  depends_on = [azurerm_storage_account_static_website.staticwebsite]
}

# resource "null_resource" "upload_files" {
#   provisioner "local-exec" {
#     command = "az storage blob upload-batch --destination '$web' --source ./website/ --account-name ${azurerm_storage_account.staticweb.name}"
#   }

#   depends_on = [azurerm_storage_account.staticweb]
# }

output "primary_web_endpoint" {
  value = azurerm_storage_account.staticweb.primary_web_endpoint
}
