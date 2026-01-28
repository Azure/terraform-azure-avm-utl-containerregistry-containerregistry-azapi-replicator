resource "azurerm_container_registry" "test" {
  name                = "testacccr${random_integer.number.result}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  admin_enabled       = true
  sku                 = "Premium"
  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = false
  quarantine_policy_enabled     = true
  retention_policy_in_days      = 10
  trust_policy_enabled          = true
  export_policy_enabled         = false
  anonymous_pull_enabled        = true
  data_endpoint_enabled         = true

  network_rule_bypass_option = "None"

  tags = {
    environment = "production"
  }
}
