resource "random_integer" "number" {
  max = 999999
  min = 100000
}

resource "azurerm_resource_group" "test" {
  location = "eastus"
  name     = "acctestRG-acr-${random_integer.number.result}"
}

module "replicator" {
  source = "../.."

  location          = azurerm_resource_group.test.location
  name              = "testacccr${random_integer.number.result}"
  resource_group_id = azurerm_resource_group.test.id
  sku               = "Basic"
  enable_telemetry  = false
}

resource "azapi_resource" "this" {
  location                         = module.replicator.azapi_header.location
  name                             = module.replicator.azapi_header.name
  parent_id                        = module.replicator.azapi_header.parent_id
  type                             = module.replicator.azapi_header.type
  body                             = module.replicator.body
  ignore_null_property             = module.replicator.azapi_header.ignore_null_property
  locks                            = module.replicator.locks
  replace_triggers_external_values = module.replicator.replace_triggers_external_values
  retry                            = module.replicator.retry
  sensitive_body                   = module.replicator.sensitive_body
  sensitive_body_version           = module.replicator.sensitive_body_version
  tags                             = module.replicator.azapi_header.tags

  dynamic "identity" {
    for_each = try(module.replicator.azapi_header.identity != null, false) ? [module.replicator.azapi_header.identity] : []

    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }
  dynamic "timeouts" {
    for_each = module.replicator.timeouts != null ? [module.replicator.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

resource "azapi_resource" "post_creation" {
  for_each = module.replicator.post_creation0 != null ? { for idx, item in module.replicator.post_creation0 : idx => item } : {}

  name           = each.value.azapi_header.name
  parent_id      = azapi_resource.this.id
  type           = each.value.azapi_header.type
  body           = each.value.body
  locks          = each.value.locks
  sensitive_body = module.replicator.post_creation0_sensitive_body

  dynamic "timeouts" {
    for_each = module.replicator.timeouts != null ? [module.replicator.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }

  depends_on = [azapi_resource.this]

  lifecycle {
    ignore_changes = [body, sensitive_body]
  }
}
