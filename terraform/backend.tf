data "azurerm_client_config" "current" {}
terraform {
  backend "azurerm" {
  }
}
