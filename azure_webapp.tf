provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "resource_group" {
    name = "az204-RG"
    location = var.azure_region
}

resource "azurerm_service_plan" "app_service_plan" {
    name = "az204-AppServicePlan"
    location = var.azure_region
    resource_group_name = azurerm_resource_group.resource_group.name
    sku_name = "F1"
    os_type = "Linux"
}

resource "azurerm_linux_web_app" "linux_web_app" {
    name = "az204-suresh"
    location = var.azure_region
    resource_group_name = azurerm_resource_group.resource_group.name
    service_plan_id = azurerm_service_plan.app_service_plan.id
    always_on = "False"

    site_config {
      always_on = false
    }
}
