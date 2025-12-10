resource "azurerm_linux_virtual_machine_scale_set" "business_vmss" {
  name                = "vmss-business"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_DS1_v2"
  instances           = 2
  admin_username      = var.admin_username

  source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
}

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key)
  }

  network_interface {
    name    = "businessnic"
    primary = true

    ip_configuration {
      name      = "businessip"
      subnet_id = azurerm_subnet.business.id
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  upgrade_mode = "Manual"
}
