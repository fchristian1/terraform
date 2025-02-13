output "azure_blob" {
  value = azurerm_storage_account.myblob.primary_blob_endpoint
}
