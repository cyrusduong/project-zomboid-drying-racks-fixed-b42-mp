## ADDED Requirements

### Requirement: Context Menu Leather Crafting
The system SHALL provide instant leather drying options when player interacts with drying racks while having wet furred leather materials in inventory.

#### Scenario: Drying Rack with Wet Leather
- **WHEN** player right-clicks on drying rack with wet furred leather items in inventory
- **THEN** context menu displays "Dry Leather" options for each compatible leather type
- **AND** options are filtered by rack size compatibility

#### Scenario: Rack Size Validation
- **WHEN** player has large leather but only small drying rack
- **THEN** context menu shows "Rack too small for this leather" message
- **AND** no drying option appears for oversized leather

#### Scenario: Upsizing Capability
- **WHEN** player has small leather but medium/large drying rack
- **THEN** context menu displays drying option for small leather

#### Scenario: Insufficient Materials
- **WHEN** player interacts with drying rack without wet furred leather materials
- **THEN** no leather drying options appear in context menu

#### Scenario: Multiplayer Environment
- **WHEN** player in B42 multiplayer environment uses drying rack
- **THEN** context menu crafting works consistently across all clients

### Requirement: Wet Furred Leather Detection
The system SHALL accurately detect wet furred leather items in player inventory for drying eligibility.

#### Scenario: Mixed Inventory
- **WHEN** player has various leather types (wet furred, dry, unprocessed)
- **THEN** system detects only wet furred leather types for drying options
- **AND** supports all 18 wet furred leather variants from vanilla game

#### Supported Wet Leather Types
- **Small (11 types)**: RabbitLeather_Fur_Tan_Wet, RabbitLeather_Grey_Fur_Tan_Wet, PigletLeather_Landrace_Fur_Tan_Wet, PigletLeather_Black_Fur_Tan_Wet, FawnLeather_Fur_Tan_Wet, LambLeather_Fur_Tan_Wet, CalfLeather_Angus_Fur_Tan_Wet, CalfLeather_Holstein_Fur_Tan_Wet, CalfLeather_Simmental_Fur_Tan_Wet, RaccoonLeather_Grey_Fur_Tan_Wet, Leather_Crude_Small_Tan_Wet
- **Medium (4 types)**: PigLeather_Landrace_Fur_Tan_Wet, PigLeather_Black_Fur_Tan_Wet, SheepLeather_Fur_Tan_Wet, Leather_Crude_Medium_Tan_Wet
- **Large (5 types)**: DeerLeather_Fur_Tan_Wet, CowLeather_Angus_Fur_Tan_Wet, CowLeather_Holstein_Fur_Tan_Wet, CowLeather_Simmental_Fur_Tan_Wet, Leather_Crude_Large_Tan_Wet

### Requirement: Instant Drying Processing
The system SHALL provide immediate drying results without time-based processing delays.

#### Scenario: Successful Drying
- **WHEN** player selects leather drying option
- **THEN** dried furred leather appears immediately in inventory
- **AND** corresponding wet leather is removed from inventory

#### Scenario: Rack Distance Requirement
- **WHEN** player attempts to dry leather from more than 2 tiles away
- **THEN** context menu option is disabled
- **AND** tooltip shows "Too far from drying rack"

### Requirement: Rack Size Compatibility
The system SHALL enforce proper rack size constraints while allowing upscaling.

#### Size Mapping Rules
- **Small Racks**: Accept small leather only
- **Medium Racks**: Accept small + medium leather
- **Large Racks**: Accept small + medium + large leather

#### Scenario: Size Mismatch
- **WHEN** player has large leather but only small rack
- **THEN** no drying option appears for that leather
- **AND** other compatible leather options still show

### Requirement: Error Handling
The system SHALL provide clear feedback when drying cannot be performed.

#### Scenario: Missing Materials
- **WHEN** player selects drying option without required wet leather
- **THEN** display "No wet furred leather available" message

#### Scenario: Rack Too Far
- **WHEN** player exceeds interaction distance
- **THEN** display "Move closer to drying rack" message

#### Scenario: Java Container Error Prevention
- **WHEN** drying rack entity processing leather items
- **THEN** system properly handles container operations without Java errors
- **AND** maintains inventory synchronization

### Requirement: Comprehensive Test Coverage
The system SHALL include Lua tests to verify all entity processing scenarios.

#### Test Scenarios
- **Inventory Detection Tests**: Verify all 18 wet leather types are properly detected
- **Rack Size Tests**: Validate size compatibility rules for all rack types
- **Distance Tests**: Ensure distance requirements work correctly
- **Multiplayer Tests**: Verify functionality in B42 environment
- **Error Handling Tests**: Test all failure scenarios and error messages
- **Integration Tests**: Validate with existing vanilla drying rack entities