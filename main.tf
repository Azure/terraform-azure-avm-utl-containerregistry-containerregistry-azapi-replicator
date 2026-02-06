locals {
  azapi_header = {
    type                 = "Microsoft.ContainerRegistry/registries@2025-04-01"
    name                 = var.name
    location             = var.location
    parent_id            = var.resource_group_id
    tags                 = var.tags
    ignore_null_property = true
    retry                = null
    identity = var.identity != null ? {
      type         = var.identity.type
      identity_ids = tolist(var.identity.identity_ids)
    } : null
  }
  body = {
    properties = merge(
      {
        adminUserEnabled         = var.admin_enabled
        anonymousPullEnabled     = var.anonymous_pull_enabled
        dataEndpointEnabled      = var.data_endpoint_enabled
        networkRuleBypassOptions = var.network_rule_bypass_option
        publicNetworkAccess      = var.public_network_access_enabled ? "Enabled" : "Disabled"
        zoneRedundancy           = var.zone_redundancy_enabled ? "Enabled" : "Disabled"
        policies = merge(
          {
            exportPolicy = {
              status = var.export_policy_enabled ? "enabled" : "disabled"
            }
          },
          {
            trustPolicy = {
              status = var.trust_policy_enabled ? "enabled" : "disabled"
            }
          },
          var.quarantine_policy_enabled != null ? {
            quarantinePolicy = {
              status = var.quarantine_policy_enabled ? "enabled" : "disabled"
            }
          } : {},
          var.retention_policy_in_days != null && var.retention_policy_in_days > 0 ? {
            retentionPolicy = {
              status = "enabled"
              days   = var.retention_policy_in_days
            }
          } : {}
        )
      },
      var.encryption != null && length(var.encryption) > 0 ? {
        encryption = {
          keyVaultProperties = {
            identity      = var.encryption[0].identity_client_id
            keyIdentifier = var.encryption[0].key_vault_key_id
          }
          status = "enabled" # Hidden field - always enabled when encryption is configured
        }
      } : {},
      var.network_rule_set != null && length(var.network_rule_set) > 0 ? {
        networkRuleSet = merge(
          {
            defaultAction = var.network_rule_set[0].default_action
          },
          var.network_rule_set[0].ip_rule != null && length(var.network_rule_set[0].ip_rule) > 0 ? {
            ipRules = [
              for rule in var.network_rule_set[0].ip_rule : {
                action = rule.action
                value  = rule.ip_range
              }
            ]
          } : {}
        )
      } : {}
    )
    sku = {
      name = var.sku
    }
  }
  locks = [] # Populated by Type 2 task
  # Post-creation operations - georeplications
  # Each georeplication is a separate child resource (Microsoft.ContainerRegistry/registries/replications)
  post_creation0 = var.georeplications != null && length(var.georeplications) > 0 ? [
    for idx, repl in var.georeplications : {
      azapi_header = {
        type                 = "Microsoft.ContainerRegistry/registries/replications@2025-04-01"
        name                 = repl.location
        location             = repl.location
        parent_id            = "${var.resource_group_id}/providers/Microsoft.ContainerRegistry/registries/${var.name}"
        tags                 = repl.tags
        ignore_null_property = true
        retry                = null
      }
      body = {
        properties = {
          regionEndpointEnabled = repl.regional_endpoint_enabled
          zoneRedundancy        = repl.zone_redundancy_enabled != null ? (repl.zone_redundancy_enabled ? "Enabled" : "Disabled") : "Disabled"
        }
      }
      locks = local.locks
    }
  ] : null
  post_creation0_sensitive_body = null # No sensitive fields in georeplications
  replace_triggers_external_values = {
    name = {
      value = var.name
    }
    resource_group_id = {
      value = var.resource_group_id
    }
    location = {
      value = var.location
    }
    zone_redundancy_enabled = {
      value = var.zone_redundancy_enabled
    }
  }
  sensitive_body = {
    properties = {}
  }
  sensitive_body_version = {}
}
