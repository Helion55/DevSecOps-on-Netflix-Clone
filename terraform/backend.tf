terraform {
  backend "azurerm" {
    resource_group_name  = "MY-BACKEND-RESOURCE-GROUP-NAME"
    storage_account_name = "MY-BACKEND-STORAGE-ACCOUNT"
    container_name       = "MY-STORAGE-CONTAINER-NAME"
    key                  = "MY-STORAGE-KEY-NAME"
  }
}
