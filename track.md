# Migration Track: azurerm_container_registry to azapi_resource

## Resource Identification

**Source Resource:** `azurerm_container_registry`

**Target Resource:** `azapi_resource`

**Azure Resource Type:** `Microsoft.ContainerRegistry/registries@2025-04-01`

## Evidence and Proof

From the azurerm provider source code (`internal/services/containers/container_registry_resource.go`):

1. **Resource Type Identification (lines 434-435):**
```go
availabilityRequest := operation.RegistryNameCheckRequest{
    Name: id.RegistryName,
    Type: "Microsoft.ContainerRegistry/registries",
}
```

2. **API Version Identification (line 21):**
```go
"github.com/hashicorp/go-azure-sdk/resource-manager/containerregistry/2025-04-01/registries"
```

3. **Create Function (line 405):**
```go
func resourceContainerRegistryCreate(d *pluginsdk.ResourceData, meta interface{}) error {
    client := meta.(*clients.Client).Containers.ContainerRegistryClient.Registries
```

This evidence confirms the azapi_resource type should be: `Microsoft.ContainerRegistry/registries@2025-04-01`

## Schema Analysis Summary

Based on the source code schema definition (lines 64-336), the resource contains:
- **Required Arguments:** 4 (name, resource_group_name, location, sku)
- **Optional Arguments:** 15
- **Optional Blocks:** 4 (encryption, georeplications, identity, network_rule_set)
- **Timeouts Block:** 1 (with 4 sub-fields)

## Planning Task List

| No. | Path | Type | Required | Status | Proof Doc Markdown Link |
|-----|------|------|----------|--------|-------------------------|
| 1 | name | Argument | Yes | Completed | [1.name.md](1.name.md) |
| 2 | resource_group_name | Argument | Yes | ✅ Completed | [2.resource_group_name.md](2.resource_group_name.md) |
| 3 | location | Argument | Yes | ✅ Completed | [3.location.md](3.location.md) |
| 4 | sku | Argument | Yes | ✅ Completed | [4.sku.md](4.sku.md) |
| 5 | admin_enabled | Argument | No | ✅ Completed | [5.admin_enabled.md](5.admin_enabled.md) |
| 6 | anonymous_pull_enabled | Argument | No | ✅ Completed | [6.anonymous_pull_enabled.md](6.anonymous_pull_enabled.md) |
| 7 | data_endpoint_enabled | Argument | No | ✅ Completed | [7.data_endpoint_enabled.md](7.data_endpoint_enabled.md) |
| 8 | export_policy_enabled | Argument | No | ✅ Completed | [8.export_policy_enabled.md](8.export_policy_enabled.md) |
| 9 | network_rule_bypass_option | Argument | No | ✅ Completed | [9.network_rule_bypass_option.md](9.network_rule_bypass_option.md) |
| 10 | public_network_access_enabled | Argument | No | ✅ Completed | [10.public_network_access_enabled.md](10.public_network_access_enabled.md) |
| 11 | quarantine_policy_enabled | Argument | No | ✅ Completed | [11.quarantine_policy_enabled.md](11.quarantine_policy_enabled.md) |
| 12 | retention_policy_in_days | Argument | No | ✅ Completed | [12.retention_policy_in_days.md](12.retention_policy_in_days.md) |
| 13 | tags | Argument | No | ✅ Completed | [13.tags.md](13.tags.md) |
| 14 | trust_policy_enabled | Argument | No | ✅ Completed | [14.trust_policy_enabled.md](14.trust_policy_enabled.md) |
| 15 | zone_redundancy_enabled | Argument | No | ✅ Completed | [15.zone_redundancy_enabled.md](15.zone_redundancy_enabled.md) |
| 16 | __check_root_hidden_fields__ | HiddenFieldsCheck | Yes | ✅ Completed | [16.__check_root_hidden_fields__.md](16.__check_root_hidden_fields__.md) |
| 17 | encryption | Block | No | ✅ Completed | [17.encryption.md](17.encryption.md) |
| 18 | encryption.identity_client_id | Argument | Yes | ✅ Completed | [18.encryption.identity_client_id.md](18.encryption.identity_client_id.md) |
| 19 | encryption.key_vault_key_id | Argument | Yes | ✅ Completed | [19.encryption.key_vault_key_id.md](19.encryption.key_vault_key_id.md) |
| 20 | georeplications | Block | No | ✅ Completed | [20.georeplications.md](20.georeplications.md) |
| 21 | georeplications.location | Argument | Yes | ✅ Completed | [21.georeplications.location.md](21.georeplications.location.md) |
| 22 | georeplications.regional_endpoint_enabled | Argument | No | ✅ Completed | [22.georeplications.regional_endpoint_enabled.md](22.georeplications.regional_endpoint_enabled.md) |
| 23 | georeplications.tags | Argument | No | ✅ Completed | [23.georeplications.tags.md](23.georeplications.tags.md) |
| 24 | georeplications.zone_redundancy_enabled | Argument | No | ✅ Completed | [24.georeplications.zone_redundancy_enabled.md](24.georeplications.zone_redundancy_enabled.md) |
| 25 | identity | Block | No | ✅ Completed | [25.identity.md](25.identity.md) |
| 26 | identity.type | Argument | Yes | ✅ Completed | [26.identity.type.md](26.identity.type.md) |
| 27 | identity.identity_ids | Argument | No | ✅ Completed | [27.identity.identity_ids.md](27.identity.identity_ids.md) |
| 28 | network_rule_set | Block | No | ✅ Completed | [28.network_rule_set.md](28.network_rule_set.md) |
| 29 | network_rule_set.default_action | Argument | No | ✅ Completed | [29.network_rule_set.default_action.md](29.network_rule_set.default_action.md) |
| 30 | network_rule_set.ip_rule | Block | No | ✅ Completed | [30.network_rule_set.ip_rule.md](30.network_rule_set.ip_rule.md) |
| 31 | network_rule_set.ip_rule.action | Argument | Yes | ✅ Completed | [31.network_rule_set.ip_rule.action.md](31.network_rule_set.ip_rule.action.md) |
| 32 | network_rule_set.ip_rule.ip_range | Argument | Yes | ✅ Completed | [32.network_rule_set.ip_rule.ip_range.md](32.network_rule_set.ip_rule.ip_range.md) |
| 33 | timeouts | Block | No | ✅ Completed | [33.timeouts.md](33.timeouts.md) |
| 34 | timeouts.create | Argument | No | ✅ Completed | [34.timeouts.create.md](34.timeouts.create.md) |
| 35 | timeouts.delete | Argument | No | ✅ Completed | [35.timeouts.delete.md](35.timeouts.delete.md) |
| 36 | timeouts.read | Argument | No | ✅ Completed | [36.timeouts.read.md](36.timeouts.read.md) |
| 37 | timeouts.update | Argument | No | ✅ Completed | [37.timeouts.update.md](37.timeouts.update.md) |

## Schema Definition References

### Required Arguments (Lines 66-93)
- `name`: Line 66-71, Required: true, ForceNew: true
- `resource_group_name`: Line 73, commonschema.ResourceGroupName()
- `location`: Line 75, commonschema.Location()
- `sku`: Line 77-84, Required: true

### Optional Arguments (Lines 86-272)
- `admin_enabled`: Line 86-90, Optional: true, Default: false
- `public_network_access_enabled`: Line 125-129, Optional: true, Default: true
- `quarantine_policy_enabled`: Line 233-236, Optional: true
- `retention_policy_in_days`: Line 238-242, Optional: true
- `trust_policy_enabled`: Line 244-248, Optional: true
- `export_policy_enabled`: Line 250-254, Optional: true
- `zone_redundancy_enabled`: Line 256-261, ForceNew: true, Optional: true, Default: false
- `anonymous_pull_enabled`: Line 263-266, Optional: true
- `data_endpoint_enabled`: Line 268-271, Optional: true
- `network_rule_bypass_option`: Line 277-284, Optional: true
- `tags`: Line 286, commonschema.Tags()

### Optional Blocks
- `encryption`: Lines 147-163, Optional: true, MaxItems: 1
  - `identity_client_id`: Line 150-153, Required: true
  - `key_vault_key_id`: Line 154-157, Required: true

- `georeplications`: Lines 92-123, Optional: true
  - `location`: Line 96, commonschema.LocationWithoutForceNew()
  - `zone_redundancy_enabled`: Line 98-102, Optional: true, Default: false
  - `regional_endpoint_enabled`: Line 104-107, Optional: true
  - `tags`: Line 109, commonschema.Tags()

- `identity`: Line 145, commonschema.SystemAssignedUserAssignedIdentityOptional()
  - `type`: Required (inferred from commonschema)
  - `identity_ids`: Optional (inferred from commonschema)

- `network_rule_set`: Lines 165-231, Optional: true, MaxItems: 1
  - `default_action`: Line 168-175, Optional: true, Default: "Allow"
  - `ip_rule`: Lines 177-196, Optional: true
    - `action`: Line 180-185, Required: true
    - `ip_range`: Line 186-189, Required: true

### Timeouts Block (Lines 57-62)
```go
Timeouts: &pluginsdk.ResourceTimeout{
    Create: pluginsdk.DefaultTimeout(30 * time.Minute),
    Read:   pluginsdk.DefaultTimeout(5 * time.Minute),
    Update: pluginsdk.DefaultTimeout(30 * time.Minute),
    Delete: pluginsdk.DefaultTimeout(30 * time.Minute),
}
```

All four timeout fields are defined: create, read, update, delete.

## Notes for Executor

1. The resource uses the old plugin SDK (`pluginsdk.Resource`)
2. Georeplications are implemented as a separate resource type in Azure API (`replications`) and require special handling
3. Several fields have SKU dependencies (Premium SKU required for certain features)
4. Network rule set and identity use common schemas from the provider
5. The encryption block is optional with MaxItems: 1
6. Timeouts are configured at the resource level with specific durations
