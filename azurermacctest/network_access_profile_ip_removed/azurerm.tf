resource "azurerm_container_registry" "test" {
  name                = "testAccCr${random_integer.number.result}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  sku                 = "Premium"
  admin_enabled       = false

  network_rule_set {
    default_action = "Allow"
  }
}
