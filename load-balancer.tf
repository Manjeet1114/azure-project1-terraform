
resource "azurerm_public_ip" "fe_pip" {
  name                = "pip-frontend-lb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
}


resource "azurerm_lb" "frontend_lb" {
  name                = "lb-frontend"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-fe"
    public_ip_address_id = azurerm_public_ip.fe_pip.id
  }
}


resource "azurerm_lb_backend_address_pool" "web_pool" {
  name            = "web-backend-pool"
  loadbalancer_id = azurerm_lb.frontend_lb.id
}

resource "azurerm_lb_probe" "http_probe" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.frontend_lb.id
  protocol        = "Http"
  request_path    = "/"
  port            = 80

  interval_in_seconds = 15
  number_of_probes    = 2
}


resource "azurerm_lb_rule" "http_rule" {
  name                           = "http-rule"
  loadbalancer_id                = azurerm_lb.frontend_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "public-fe"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.web_pool.id
  ]

  probe_id = azurerm_lb_probe.http_probe.id
}
