provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "resource_group_vm" {
    name = "az204-RG"
    location = var.azure_region
}

resource "azurerm_virtual_network" "virtual_network" {
  name = "az104-network"
  address_space = ["10.0.0.0/16"]
  location = var.azure_region
  resource_group_name = azurerm_resource_group.resource_group_vm.name
}

resource "azurerm_subnet" "subnet" {
    name = "az104-subnet"
    resource_group_name = azurerm_resource_group.resource_group_vm.name
    virtual_network_name = azurerm_virtual_network.virtual_network.name
    address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "network_interface" {
    name = "az104-nw-interface"
    location = var.azure_region
    resource_group_name = azurerm_resource_group.resource_group_vm.name

    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
    name = "az104-Virtual-Machine"
    resource_group_name = azurerm_resource_group.resource_group_vm.name
    location = var.azure_region
    size = "Standard_B1s"
    admin_username = var.azure_admin_user_name
    network_interface_ids = [
        azurerm_network_interface.network_interface.id,
    ]

    admin_ssh_key {
      username = var.azure_admin_user_name
      public_key = file(var.azure_ssh_key)
    }

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }
}