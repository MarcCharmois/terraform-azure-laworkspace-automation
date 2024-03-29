provider "azurerm" {
  version         = "~>1.27"
  subscription_id = "${var.subscription_Id}"
}

data "azurerm_subscription" "current" {

}
resource "azurerm_resource_group" "rg" {
  name     = "${var.resourceGroupName}"
  location = "francecentral"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-laworkspace-${var.subscription_Id}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku                 = "PerGB2018"
}

resource "azurerm_automation_account" "automation" {
  name                = "${var.prefix}-automationAccount1"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku_name = "Basic"

  tags = {
    environment = "development"
  }
}

resource "azurerm_automation_variable_string" "law-id" {
  name                    = "la-workspaceId"
  automation_account_name = "${azurerm_automation_account.automation.name}"
  resource_group_name     = "${azurerm_resource_group.rg.name}"
  value                   = "${azurerm_log_analytics_workspace.law.workspace_id}"
  encrypted               = "false"
}

resource "azurerm_automation_variable_string" "law-key" {
  name                    = "la-workspaceKey"
  automation_account_name = "${azurerm_automation_account.automation.name}"
  resource_group_name     = "${azurerm_resource_group.rg.name}"
  value                   = "${azurerm_log_analytics_workspace.law.primary_shared_key}"
  encrypted               = "true"
}
