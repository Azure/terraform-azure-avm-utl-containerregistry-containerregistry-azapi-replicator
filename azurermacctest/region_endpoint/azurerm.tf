resource "azurerm_container_registry" "test" {
  name                = "testacccr${random_integer.number.result}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  sku                 = "Premium"
  georeplications {
    location                  = "westus"
    regional_endpoint_enabled = true
  }
}
