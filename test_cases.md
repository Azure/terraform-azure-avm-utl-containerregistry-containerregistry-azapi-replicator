# Test Configuration Functions for azurerm_container_registry

## Test Cases Summary Table

| Case Name | File URL | Status | Test Status |
| --- | --- | --- | --- |
| basic | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| basicManaged_Standard | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| basic_managed_premium | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| complete | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| completeUpdated | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| downgradeSku | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| geoReplicationLocation | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| geoReplicationMultipleLocations | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | invalid |
| geoReplicationMultipleLocationsUpdate | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | invalid |
| geoReplicationUpdateWithNoLocationBasic | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| networkAccessProfileIp | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| networkAccessProfileIpRemoved | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| networkAccessProfileNetworkRuleSetRemoved | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| zoneRedundancy | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| geoReplicationZoneRedundancy | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | invalid |
| regionEndpoint | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| anonymousPullStandard_false | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| anonymousPullStandard_true | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| dataEndpointPremium_false | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| dataEndpointPremium_true | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | |
| networkRuleBypassOptionsPremium_None | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| networkRuleBypassOptionsPremium_AzureServices | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |
| encryptionEnabled | https://raw.githubusercontent.com/hashicorp/terraform-provider-azurerm/refs/heads/main/internal/services/containers/container_registry_resource_test.go | Completed | test success |

---

## Detailed Test Case Categories

### Basic/Foundation Cases (3 cases):
1. **`r.basic(data)`** - Basic container registry with Basic SKU
   - Minimal configuration with Basic SKU
   - Tests core resource creation

2. **`r.basicManaged(data, "Standard")`** - Basic managed container registry with Standard SKU
   - Standard SKU configuration
   - Tests managed registry tier

3. **`r.basicManaged(data, "Premium")`** - Basic managed container registry with Premium SKU
   - Premium SKU configuration
   - Required for advanced features

### Complete/Advanced Configuration Cases (3 cases):
4. **`r.complete(data)`** - Complete configuration with all features
   - Includes: admin_enabled, SystemAssigned identity, public_network_access_enabled=false
   - Features: quarantine_policy, retention_policy, trust_policy, export_policy, anonymous_pull, data_endpoint
   - Network rule bypass option set to "None"
   - Tests comprehensive feature set

5. **`r.completeUpdated(data)`** - Updated complete configuration
   - Changes identity from SystemAssigned to UserAssigned
   - Toggles various policy settings
   - Updates network rule bypass option to "AzureServices"
   - Tests update scenarios with complex configurations

6. **`r.downgradeSku(data)`** - Downgrade SKU from Premium to Basic
   - Tests SKU downgrade path
   - Maintains admin_enabled and SystemAssigned identity

### Geo-Replication Cases (6 cases):
7. **`r.geoReplicationLocation(data, replicationRegion)`** - Single geo-replication location
   - Premium SKU with single replication region
   - Tests basic geo-replication setup

8. **`r.geoReplicationMultipleLocations(data, primaryLocation, secondaryLocation)`** - Multiple geo-replication locations
   - Premium SKU with two replication regions
   - Tests multiple replicas

9. **`r.geoReplicationMultipleLocationsUpdate(data, primaryLocation, secondaryLocation)`** - Updated geo-replication with advanced settings
   - Adds zone_redundancy_enabled to one location
   - Adds regional_endpoint_enabled and tags to another location
   - Tests geo-replication feature updates

10. **`r.geoReplicationUpdateWithNoLocationBasic(data)`** - Remove geo-replication by downgrading to Basic SKU
    - Downgrades from Premium to Basic, removing geo-replications
    - Explicitly sets empty network_rule_set for Basic SKU
    - Tests clean removal of geo-replication

11. **`r.geoReplicationZoneRedundancy(data)`** - Geo-replication with zone redundancy
    - Premium SKU with zone_redundancy_enabled on replica
    - Tests zone redundancy in geo-replication

12. **`r.regionEndpoint(data)`** - Geo-replication with regional endpoint
    - Premium SKU with regional_endpoint_enabled on replica
    - Tests regional endpoint feature

### Network Configuration Cases (3 cases):
13. **`r.networkAccessProfileIp(data, sku)`** - Network rules with IP restrictions
    - Configures network_rule_set with multiple IP rules
    - Tests IP-based access control
    - Used with "Premium" SKU

14. **`r.networkAccessProfileIpRemoved(data, sku)`** - Network rules with IP restrictions removed
    - Maintains network_rule_set but removes IP rules
    - Tests IP rule removal
    - Used with "Premium" SKU

15. **`r.networkAccessProfileNetworkRuleSetRemoved(data, sku)`** - Complete network rule set removal
    - Removes entire network_rule_set
    - Tests removal of network configuration
    - Used with "Basic" SKU

### Zone Redundancy Cases (1 case):
16. **`r.zoneRedundancy(data)`** - Zone redundancy enabled on primary registry
    - Premium SKU with zone_redundancy_enabled on main registry
    - Tests zone redundancy feature

### Feature Toggle Cases (6 cases):
17. **`r.anonymousPullStandard(data, false)`** - Anonymous pull disabled
    - Standard SKU with anonymous_pull_enabled=false
    - Tests anonymous pull feature (disabled state)

18. **`r.anonymousPullStandard(data, true)`** - Anonymous pull enabled
    - Standard SKU with anonymous_pull_enabled=true
    - Tests anonymous pull feature (enabled state)

19. **`r.dataEndpointPremium(data, false)`** - Data endpoint disabled
    - Premium SKU with data_endpoint_enabled=false
    - Tests data endpoint feature (disabled state)

20. **`r.dataEndpointPremium(data, true)`** - Data endpoint enabled
    - Premium SKU with data_endpoint_enabled=true
    - Tests data endpoint feature (enabled state)

21. **`r.networkRuleBypassOptionsPremium(data, "None")`** - Network rule bypass set to None
    - Premium SKU with network_rule_bypass_option="None"
    - Tests strict network isolation

22. **`r.networkRuleBypassOptionsPremium(data, "AzureServices")`** - Network rule bypass set to AzureServices
    - Premium SKU with network_rule_bypass_option="AzureServices"
    - Tests Azure services bypass

### Encryption Cases (1 case):
23. **`r.encryptionEnabled(data)`** - Customer-managed key encryption
    - Premium SKU with UserAssigned identity
    - Configures encryption with Key Vault key
    - Tests CMK encryption setup

---

## Removed Cases

- ❌ **`r.requiresImport(data, sku)`** - Error test case (used with ExpectError to validate import rejection)
- ❌ **`r.encryptionTemplate(data)`** - Helper/template function (only called by encryptionEnabled, provides Key Vault infrastructure)

---

## Test Method Usage Analysis

### Update/Lifecycle Test Methods
These test methods verify transitions between valid configurations:

- **TestAccContainerRegistry_basic2Premium2basic**: Tests SKU transitions (Basic → Premium → Basic)
  - Uses: `r.basic(data)` → `r.basicManaged(data, "Premium")` → `r.basic(data)`

- **TestAccContainerRegistry_update**: Tests comprehensive update scenarios
  - Uses: `r.complete(data)` → `r.completeUpdated(data)` → `r.downgradeSku(data)`

- **TestAccContainerRegistry_geoReplicationLocation**: Tests geo-replication updates
  - Uses: `r.geoReplicationLocation(data, secondaryLocation)` → `r.geoReplicationLocation(data, ternaryLocation)` → `r.geoReplicationMultipleLocations(...)` → `r.geoReplicationMultipleLocationsUpdate(...)` → `r.geoReplicationUpdateWithNoLocationBasic(data)`

- **TestAccContainerRegistry_networkAccessProfileIp**: Tests network profile updates
  - Uses: `r.networkAccessProfileIp(data, "Premium")` → `r.networkAccessProfileIpRemoved(data, "Premium")` → `r.networkAccessProfileNetworkRuleSetRemoved(data, "Basic")`

- **TestAccContainerRegistry_networkAccessProfileUpdate**: Tests adding network profile
  - Uses: `r.basicManaged(data, "Premium")` → `r.networkAccessProfileIp(data, "Premium")`

- **TestAccContainerRegistry_anonymousPull**: Tests toggling anonymous pull
  - Uses: `r.anonymousPullStandard(data, false)` → `r.anonymousPullStandard(data, true)` → `r.anonymousPullStandard(data, false)`

- **TestAccContainerRegistry_dataEndpoint**: Tests toggling data endpoint
  - Uses: `r.dataEndpointPremium(data, false)` → `r.dataEndpointPremium(data, true)` → `r.dataEndpointPremium(data, false)`

- **TestAccContainerRegistry_networkRuleBypassOption**: Tests toggling bypass option
  - Uses: `r.networkRuleBypassOptionsPremium(data, "None")` → `r.networkRuleBypassOptionsPremium(data, "AzureServices")` → `r.networkRuleBypassOptionsPremium(data, "None")`

---

## Validation Checklist

- [x] All test files matching `container_registry_resource*_test.go` pattern have been identified (1 file found, no legacy files)
- [x] All test files have been scanned for configuration functions
- [x] All functions used directly in `TestStep.Config` are included
- [x] All functions with `ExpectError` in same TestStep are excluded (requiresImport)
- [x] All helper functions (only called by other functions) are excluded (encryptionTemplate)
- [x] All `requiresImport` variants are excluded
- [x] Each case has a clear, descriptive label
- [x] Cases are logically categorized
- [x] Total count is accurate (23 valid test cases)
- [x] File source is documented for each test case

---

**Total Valid Test Cases**: 23

**Total Test Files Analyzed**: 1
- `container_registry_resource_test.go` - Main test file with all test cases












