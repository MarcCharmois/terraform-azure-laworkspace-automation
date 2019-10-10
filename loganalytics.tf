provider "azurerm" {
    version = "=1.20.0"
}
resource "azurerm_resource_group" "rg" {
    name     = "myTFResourceGroup"
    location = "francecentral"
}