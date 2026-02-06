resource "azurerm_container_registry" "test" {
  name                = "testacccr${random_integer.number.result}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  admin_enabled       = true
  sku                 = "Premium"

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.test.id
    ]
  }

  public_network_access_enabled = true
  quarantine_policy_enabled     = false
  retention_policy_in_days      = 15
  trust_policy_enabled          = false
  export_policy_enabled         = true
  anonymous_pull_enabled        = false
  data_endpoint_enabled         = false

  network_rule_bypass_option = "AzureServices"

  tags = {
    environment = "production"
    oompa       = "loompa"
  }
}
