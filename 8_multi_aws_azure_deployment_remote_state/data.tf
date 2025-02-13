data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*24.04*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical
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
