# random password for SQL admin
resource "random_password" "sql_password" {
  length  = 20
  special = true
}

# random suffix for unique server names
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  numeric = true
  special = false
}

# Primary SQL Server
resource "azurerm_mssql_server" "primary" {
  name                         = "sql-primary-${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = "eastus2"
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = random_password.sql_password.result

  tags = {
    role = "primary-sql"
  }
}

# Database on primary
resource "azurerm_mssql_database" "appdb" {
  name      = "bankingdb"
  server_id = azurerm_mssql_server.primary.id
  sku_name  = "S0"
}

# Secondary SQL Server (could be in another region)
resource "azurerm_mssql_server" "secondary" {
  name                         = "sql-secondary-${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location  # change to another region if desired (e.g., "eastus2")
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = random_password.sql_password.result

  tags = {
    role = "secondary-sql"
  }
}

# Failover group (Manual failover)
resource "azurerm_mssql_failover_group" "failover" {
  name      = "sql-fo-group"
  server_id = azurerm_mssql_server.primary.id

  # list of databases to include in the failover group
  databases = [
    azurerm_mssql_database.appdb.id
  ]

  # partner server block
  partner_server {
    id = azurerm_mssql_server.secondary.id
  }

  read_write_endpoint_failover_policy {
    mode = "Manual"   
  }

  tags = {
    role = "failover-group"
  }
}
