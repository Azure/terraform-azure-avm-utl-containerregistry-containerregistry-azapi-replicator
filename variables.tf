variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  nullable    = false
}

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Container Registry. Only Alphanumeric characters allowed. Changing this forces a new resource to be created."
  nullable    = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.name))
    error_message = "alpha numeric characters only are allowed in 'name': ${var.name}"
  }
  validation {
    condition     = length(var.name) >= 5
    error_message = "'name' cannot be less than 5 characters: ${var.name}"
  }
  validation {
    condition     = length(var.name) <= 50
    error_message = "'name' cannot be longer than 50 characters: ${var.name} (${length(var.name)})"
  }
}

variable "resource_group_id" {
  type        = string
  description = "(Required) The resource ID of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  nullable    = false

  validation {
    condition     = can(regex("^/subscriptions/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/resourceGroups/[-\\w\\._\\(\\)]+[^\\.]$", var.resource_group_id))
    error_message = "'resource_group_id' must be a valid resource group ID in the format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}. Resource group names can contain alphanumeric characters, periods, underscores, hyphens, and parentheses, cannot end with a period, and must be 1-90 characters long."
  }
}

variable "sku" {
  type        = string
  description = "(Required) The SKU name of the container registry. Possible values are `Basic`, `Standard` and `Premium`."
  nullable    = false

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "'sku' must be one of: Basic, Standard, Premium"
  }
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to `false`."
  nullable    = false
}

variable "anonymous_pull_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether to allow anonymous (unauthenticated) pull access to this Container Registry. This is only supported on resources with the `Standard` or `Premium` SKU."

  validation {
    condition     = var.anonymous_pull_enabled == null || var.anonymous_pull_enabled == false || contains(["Standard", "Premium"], var.sku)
    error_message = "`anonymous_pull_enabled` can only be applied when using the Standard/Premium Sku"
  }
}

variable "data_endpoint_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether to enable dedicated data endpoints for this Container Registry? This is only supported on resources with the `Premium` SKU."

  validation {
    condition     = var.data_endpoint_enabled != true || var.sku == "Premium"
    error_message = "`data_endpoint_enabled` can only be applied when using the Premium Sku"
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "encryption" {
  type = list(object({
    identity_client_id = string
    key_vault_key_id   = string
  }))
  default     = null
  description = <<-EOT
 - `identity_client_id` - (Required) The client ID of the managed identity associated with the encryption key.
 - `key_vault_key_id` - (Required) The ID of the Key Vault Key.
EOT

  validation {
    condition     = var.encryption == null || length(var.encryption) == 0 || var.sku == "Premium"
    error_message = "an ACR encryption can only be applied when using the Premium Sku"
  }
  validation {
    condition     = var.encryption == null || length(var.encryption) <= 1
    error_message = "encryption block can have at most 1 item"
  }
  validation {
    condition     = var.encryption == null || length(var.encryption) == 0 || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.encryption[0].identity_client_id))
    error_message = "identity_client_id must be a valid UUID"
  }
  validation {
    condition     = var.encryption == null || length(var.encryption) == 0 || can(regex("^https://[a-zA-Z0-9-]+\\.vault(\\.[a-zA-Z0-9-]+)*\\.[a-z]{2,}(/[a-zA-Z0-9-]+){2,3}(/[a-fA-F0-9]{32})?$", var.encryption[0].key_vault_key_id))
    error_message = "key_vault_key_id must be a valid Key Vault Key ID in the format: https://{vault-name}.vault.{dns-suffix}/keys/{key-name}/{version} where version is optional"
  }
}

variable "export_policy_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Boolean value that indicates whether export policy is enabled. Defaults to `true`. In order to set it to `false`, make sure the `public_network_access_enabled` is also set to `false`."
  nullable    = false

  validation {
    condition     = var.export_policy_enabled == true || var.sku == "Premium"
    error_message = "an ACR export policy can only be disabled when using the Premium Sku. If you are downgrading from a Premium SKU please unset `export_policy_enabled` or set `export_policy_enabled = true`"
  }
  validation {
    condition     = var.export_policy_enabled == true || var.public_network_access_enabled == false
    error_message = "to disable export of artifacts, `public_network_access_enabled` must also be `false`"
  }
}

variable "georeplications" {
  type = list(object({
    location                  = string
    regional_endpoint_enabled = optional(bool)
    tags                      = optional(map(string))
    zone_redundancy_enabled   = optional(bool)
  }))
  default     = null
  description = <<-EOT
 - `location` - (Required) A location where the container registry should be geo-replicated.
 - `regional_endpoint_enabled` - (Optional) Whether regional endpoint is enabled for this Container Registry?
 - `tags` - (Optional) A mapping of tags to assign to this replication location.
 - `zone_redundancy_enabled` - (Optional) Whether zone redundancy is enabled for this replication location? Defaults to `false`.
EOT

  validation {
    condition = var.georeplications == null || alltrue([
      for repl in var.georeplications :
      can(regex("^[a-z0-9]+$", replace(lower(repl.location), " ", "")))
    ])
    error_message = "Each georeplication location must be a valid Azure region name."
  }
  validation {
    condition = var.georeplications == null || length(var.georeplications) == 0 || !contains([
      for repl in var.georeplications :
      replace(lower(repl.location), " ", "")
    ], replace(lower(var.location), " ", ""))
    error_message = "The `georeplications` list cannot contain the location where the Container Registry exists."
  }
  validation {
    condition = var.georeplications == null || length(var.georeplications) == length(distinct([
      for repl in var.georeplications :
      replace(lower(repl.location), " ", "")
    ]))
    error_message = "Each georeplication location must be unique within the `georeplications` list."
  }
  validation {
    condition     = var.georeplications == null || length(var.georeplications) == 0 || var.sku == "Premium"
    error_message = "An ACR geo-replication can only be applied when using the Premium Sku."
  }
  validation {
    condition = var.georeplications == null || alltrue([
      for repl in var.georeplications :
      repl.zone_redundancy_enabled == null || !repl.zone_redundancy_enabled || var.sku == "Premium"
    ])
    error_message = "ACR zone redundancy can only be applied when using the Premium Sku."
  }
}

variable "identity" {
  type = object({
    identity_ids = optional(set(string))
    type         = string
  })
  default     = null
  description = <<-EOT
 - `identity_ids` - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry.
 - `type` - (Required) Specifies the type of Managed Service Identity that should be configured on this Container Registry. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both).
EOT

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "identity.type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned"
  }
  validation {
    condition = var.identity == null || (
      (var.identity.identity_ids == null || length(var.identity.identity_ids) == 0) ||
      (var.identity.type == "UserAssigned" || var.identity.type == "SystemAssigned, UserAssigned")
    )
    error_message = "`identity_ids` can only be specified when `type` is set to \"UserAssigned\" or \"SystemAssigned, UserAssigned\""
  }
}

variable "network_rule_bypass_option" {
  type        = string
  default     = "AzureServices"
  description = "(Optional) Whether to allow trusted Azure services to access a network-restricted Container Registry? Possible values are `None` and `AzureServices`. Defaults to `AzureServices`."
  nullable    = false

  validation {
    condition     = contains(["AzureServices", "None"], var.network_rule_bypass_option)
    error_message = "'network_rule_bypass_option' must be one of: AzureServices, None"
  }
}

variable "network_rule_set" {
  type = list(object({
    default_action = optional(string, "Allow")
    ip_rule = set(object({
      action   = string
      ip_range = string
    }))
  }))
  default     = null
  description = <<-EOT
 - `default_action` - (Optional) The behaviour for requests matching no rules. Either `Allow` or `Deny`. Defaults to `Allow`

 ---
 `ip_rule` block supports the following:
 - `action` - (Required) The behaviour for requests matching this rule. At this time the only supported value is `Allow`
 - `ip_range` - (Required) The CIDR block from which requests will match the rule.
EOT

  validation {
    condition     = var.network_rule_set == null || length(var.network_rule_set) == 0 || var.sku == "Premium"
    error_message = "`network_rule_set` can only be specified for a Premium SKU. If you are reverting from a Premium to Basic SKU please set network_rule_set = []"
  }
  validation {
    condition = var.network_rule_set == null || length(var.network_rule_set) == 0 || alltrue([
      for nrs in var.network_rule_set :
      contains(["Allow", "Deny"], nrs.default_action)
    ])
    error_message = "default_action must be one of: Allow, Deny"
  }
  validation {
    condition = var.network_rule_set == null || length(var.network_rule_set) == 0 || alltrue([
      for nrs in var.network_rule_set :
      nrs.ip_rule == null || alltrue([
        for rule in nrs.ip_rule :
        rule.action == "Allow"
      ])
    ])
    error_message = "ip_rule.action must be 'Allow' (only supported value at this time)"
  }
  validation {
    condition = var.network_rule_set == null || length(var.network_rule_set) == 0 || alltrue([
      for nrs in var.network_rule_set :
      nrs.ip_rule == null || alltrue([
        for rule in nrs.ip_rule :
        can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}(/([0-9]|[1-2][0-9]|3[0-2]))?$", rule.ip_range))
      ])
    ])
    error_message = "ip_rule.ip_range must start with IPv4 address and/or slash, number of bits (0-32) as prefix. Example: 127.0.0.1/8"
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether public network access is allowed for the container registry. Defaults to `true`."
  nullable    = false

  validation {
    condition     = var.public_network_access_enabled == true || var.sku == "Premium"
    error_message = "`public_network_access_enabled` can only be disabled for a Premium Sku"
  }
}

variable "quarantine_policy_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Boolean value that indicates whether quarantine policy is enabled."

  validation {
    condition     = var.quarantine_policy_enabled != true || var.sku == "Premium"
    error_message = "an ACR quarantine policy can only be applied when using the Premium Sku. If you are downgrading from a Premium SKU please unset quarantine_policy_enabled"
  }
}

variable "retention_policy_in_days" {
  type        = number
  default     = null
  description = "(Optional) The number of days to retain and untagged manifest after which it gets purged."

  validation {
    condition     = var.retention_policy_in_days == null || (var.retention_policy_in_days >= 0 && var.retention_policy_in_days <= 365)
    error_message = "'retention_policy_in_days' must be between 0 and 365 inclusive."
  }
  validation {
    condition     = var.retention_policy_in_days == null || var.retention_policy_in_days == 0 || var.sku == "Premium"
    error_message = "an ACR retention policy can only be applied when using the Premium Sku. If you are downgrading from a Premium SKU please unset `retention_policy_in_days`"
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) A mapping of tags to assign to the resource."
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    read   = optional(string, "5m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
  description = <<-EOT
 - `create` - (Optional) Specifies the timeout for create operations. Defaults to 30 minutes.
 - `delete` - (Optional) Specifies the timeout for delete operations. Defaults to 30 minutes.
 - `read` - (Optional) Specifies the timeout for read operations. Defaults to 5 minutes.
 - `update` - (Optional) Specifies the timeout for update operations. Defaults to 30 minutes.
EOT
  nullable    = false
}

variable "trust_policy_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Boolean value that indicated whether trust policy is enabled. Defaults to `false`."
  nullable    = false

  validation {
    condition     = !var.trust_policy_enabled || var.sku == "Premium"
    error_message = "an ACR trust policy can only be applied when using the Premium Sku. If you are downgrading from a Premium SKU please unset `trust_policy_enabled` or set `trust_policy_enabled = false`"
  }
}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether zone redundancy is enabled for this Container Registry? Changing this forces a new resource to be created. Defaults to `false`."
  nullable    = false

  validation {
    condition     = !var.zone_redundancy_enabled || var.sku == "Premium"
    error_message = "ACR zone redundancy can only be applied when using the Premium Sku"
  }
}
