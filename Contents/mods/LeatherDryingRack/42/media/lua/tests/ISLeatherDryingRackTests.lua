require "ISLeatherDryingRackMenu"
require "LeatherDryingRackData"

-- Test harness for leather drying rack functionality
ISLeatherDryingRackTests = {}

-- Mock data structures for testing
ISLeatherDryingRackTests.mockPlayer = {
    inventory = {
        items = {},
        getFirstTagRecurse = function(self, itemType)
            for _, item in ipairs(self.items) do
                if item.type == itemType then
                    return item
                end
            end
            return nil
        end,
        Remove = function(self, item)
            for i, existingItem in ipairs(self.items) do
                if existingItem == item then
                    table.remove(self.items, i)
                    return
                end
            end
        end,
        AddItem = function(self, itemType)
            local newItem = {
                type = itemType,
                getDisplayName = function(self)
                    return itemType
                end
            }
            table.insert(self.items, newItem)
            return newItem
        end
    },
    getInventory = function(self)
        return self.inventory
    end,
    getCurrentSquare = function(self)
        return {getX = function() return 0 end, getY = function() return 0 end}
    end,
    getVehicle = function(self) return nil end,
    Say = function(self, message) print("PLAYER SAYS: " .. message) end
}

ISLeatherDryingRackTests.mockRack = {
    name = "Drying_Rack",
    getDisplayName = function(self) return "Drying Rack" end,
    getName = function(self) return self.name end,
    getSquare = function(self)
        return {getX = function() return 1 end, getY = function() return 1 end}
    end
}

-- Test 1: Leather mapping completeness
function ISLeatherDryingRackTests.testLeatherMappingCompleteness()
    print("=== Test 1: Leather Mapping Completeness ===")
    
    local expectedInputs = 20 -- 11 small + 4 medium + 5 large
    local actualInputs = 0
    
    for size, data in pairs(LeatherDryingRackData) do
        actualInputs = actualInputs + #data.inputs
        print("Size " .. size .. ": " .. #data.inputs .. " inputs, " .. #data.outputs .. " outputs")
        
        -- Verify input/output count matches
        if #data.inputs ~= #data.outputs then
            print("ERROR: Input/output count mismatch for size " .. size)
        end
    end
    
    if actualInputs == expectedInputs then
        print("PASS: All " .. expectedInputs .. " leather types mapped")
    else
        print("FAIL: Expected " .. expectedInputs .. " inputs, found " .. actualInputs)
    end
end

-- Test 2: Leather mapping lookup functionality
function ISLeatherDryingRackTests.testLeatherMappingLookup()
    print("\n=== Test 2: Leather Mapping Lookup ===")
    
    local testCases = {
        {
            input = "Base.RabbitLeather_Fur_Tan_Wet",
            expectedOutput = "Base.RabbitLeather_Fur_Tan",
            expectedSize = "small"
        },
        {
            input = "Base.PigLeather_Landrace_Fur_Tan_Wet",
            expectedOutput = "Base.PigLeather_Landrace_Fur_Tan",
            expectedSize = "medium"
        },
        {
            input = "Base.DeerLeather_Fur_Tan_Wet",
            expectedOutput = "Base.DeerLeather_Fur_Tan",
            expectedSize = "large"
        }
    }
    
    local passedTests = 0
    local totalTests = #testCases
    
    for _, testCase in ipairs(testCases) do
        local mapping = LeatherDryingRackMapping[testCase.input]
        
        if mapping and mapping.output == testCase.expectedOutput and mapping.size == testCase.expectedSize then
            print("PASS: " .. testCase.input .. " → " .. mapping.output .. " (size: " .. mapping.size .. ")")
            passedTests = passedTests + 1
        else
            print("FAIL: " .. testCase.input .. " - Expected " .. testCase.expectedOutput .. " (size: " .. testCase.expectedSize .. ")")
            if mapping then
                print("  Got: " .. mapping.output .. " (size: " .. mapping.size .. ")")
            else
                print("  Got: No mapping found")
            end
        end
    end
    
    print("Lookup test results: " .. passedTests .. "/" .. totalTests .. " passed")
end

-- Test 3: Rack type detection (using Utils)
function ISLeatherDryingRackTests.testRackTypeDetection()
    print("\n=== Test 3: Rack Type Detection ===")
    
    local testCases = {
        {name = "Simple_Drying_Rack_1_0", expected = "small"},
        {name = "Herb_Drying_Rack_1_0", expected = "small"},
        {name = "Drying_Rack_1_0", expected = "medium"},
        {name = "Unknown_Rack", expected = "medium"} -- default case
    }
    
    local passedTests = 0
    local totalTests = #testCases
    
    for _, testCase in ipairs(testCases) do
        local mockEntity = {getName = function() return testCase.name end}
        local detectedType = LeatherDryingRackUtils.getRackType(mockEntity)
        
        if detectedType == testCase.expected then
            print("PASS: " .. testCase.name .. " → " .. detectedType)
            passedTests = passedTests + 1
        else
            print("FAIL: " .. testCase.name .. " → Expected " .. testCase.expected .. ", got " .. detectedType)
        end
    end
    
    print("Rack type detection results: " .. passedTests .. "/" .. totalTests .. " passed")
end

-- Test 4: Rack size compatibility (using Utils)
function ISLeatherDryingRackTests.testRackSizeCompatibility()
    print("\n=== Test 4: Rack Size Compatibility ===")
    
    local testCases = {
        {rackType = "small", expectedSizes = {small = true, medium = false, large = false}},
        {rackType = "medium", expectedSizes = {small = true, medium = true, large = false}},
        {rackType = "large", expectedSizes = {small = true, medium = true, large = true}}
    }
    
    local passedTests = 0
    local totalTests = #testCases
    
    for _, testCase in ipairs(testCases) do
        local compatibleSizes = LeatherDryingRackUtils.getCompatibleSizes(testCase.rackType)
        
        local isMatch = true
        for size, expected in pairs(testCase.expectedSizes) do
            if (compatibleSizes[size] or false) ~= expected then
                isMatch = false
                print("  Mismatch for " .. size .. ": expected " .. tostring(expected) .. ", got " .. tostring(compatibleSizes[size]))
            end
        end
        
        if isMatch then
            print("PASS: " .. testCase.rackType .. " rack has correct size compatibility")
            passedTests = passedTests + 1
        else
            print("FAIL: " .. testCase.rackType .. " rack size compatibility mismatch")
        end
    end
    
    print("Size compatibility results: " .. passedTests .. "/" .. totalTests .. " passed")
end

-- Test 5: Distance calculation (using Utils)
function ISLeatherDryingRackTests.testDistanceCalculation()
    print("\n=== Test 5: Distance Calculation ===")
    
    local testCases = {
        {playerX = 0, playerY = 0, rackX = 1, rackY = 1, expected = true},  -- sqrt(2) ≈ 1.41 <= 2
        {playerX = 0, playerY = 0, rackX = 2, rackY = 1, expected = false}, -- sqrt(5) ≈ 2.23 > 2
        {playerX = 0, playerY = 0, rackX = 3, rackY = 0, expected = false}, -- sqrt(9) = 3 > 2
    }
    
    local passedTests = 0
    local totalTests = #testCases
    
    for _, testCase in ipairs(testCases) do
        local mockPlayer = {
            getCurrentSquare = function()
                return {
                    getX = function() return testCase.playerX end,
                    getY = function() return testCase.playerY end
                }
            end
        }
        
        local mockRack = {
            getSquare = function()
                return {
                    getX = function() return testCase.rackX end,
                    getY = function() return testCase.rackY end
                }
            end
        }
        
        local isNear = LeatherDryingRackUtils.isPlayerNearRack(mockPlayer, mockRack)
        
        if isNear == testCase.expected then
            print("PASS: Distance (" .. testCase.playerX .. "," .. testCase.playerY .. ") to (" .. testCase.rackX .. "," .. testCase.rackY .. ") → " .. tostring(isNear))
            passedTests = passedTests + 1
        else
            print("FAIL: Distance (" .. testCase.playerX .. "," .. testCase.playerY .. ") to (" .. testCase.rackX .. "," .. testCase.rackY .. ") → Expected " .. tostring(testCase.expected) .. ", got " .. tostring(isNear))
        end
    end
    
    print("Distance calculation results: " .. passedTests .. "/" .. totalTests .. " passed")
end

-- Test 6: Wet leather detection in inventory (using Utils)
function ISLeatherDryingRackTests.testWetLeatherDetection()
    print("\n=== Test 6: Wet Leather Detection ===")
    
    local mockPlayer = ISLeatherDryingRackTests.mockPlayer
    
    -- Add some test items to mock inventory
    mockPlayer.inventory.items = {
        {type = "Base.RabbitLeather_Fur_Tan_Wet", getDisplayName = function() return "Rabbit Hide (Furred, Wet)" end},
        {type = "Base.PigLeather_Landrace_Fur_Tan_Wet", getDisplayName = function() return "Pig Hide (Furred, Wet)" end},
        {type = "Base.DriedLeather_NotWet", getDisplayName = function() return "Dried Leather" end} -- Should not be detected
    }
    
    local detectedItems = LeatherDryingRackUtils.getWetLeatherItems(mockPlayer)
    
    if #detectedItems == 2 then
        print("PASS: Detected 2 wet leather items")
        for _, item in ipairs(detectedItems) do
            print("  - " .. item.item:getDisplayName() .. " → " .. item.outputType)
        end
    else
        print("FAIL: Expected 2 wet leather items, detected " .. #detectedItems)
    end
end

-- Test 7: Leather drying process
function ISLeatherDryingRackTests.testLeatherDryingProcess()
    print("\n=== Test 7: Leather Drying Process ===")
    
    local mockPlayer = ISLeatherDryingRackTests.mockPlayer
    local mockRack = ISLeatherDryingRackTests.mockRack
    
    -- Add wet leather to inventory
    local wetItem = {
        type = "Base.RabbitLeather_Fur_Tan_Wet",
        getDisplayName = function() return "Rabbit Hide (Furred, Wet)" end
    }
    mockPlayer.inventory.items = {wetItem}
    
    local leatherData = {
        item = wetItem,
        outputType = "Base.RabbitLeather_Fur_Tan",
        size = "small"
    }
    
    -- Mock sendAddItemToContainer which is global in PZ
    _G.sendAddItemToContainer = function() end
    
    -- Perform drying
    ISLeatherDryingRackMenu.dryLeather(mockPlayer, leatherData, mockRack)
    
    -- Verify results
    if #mockPlayer.inventory.items == 1 then
        local driedItem = mockPlayer.inventory.items[1]
        if driedItem.type == "Base.RabbitLeather_Fur_Tan" then
            print("PASS: Wet leather transformed to dried leather")
        else
            print("FAIL: Expected dried leather, got " .. driedItem.type)
        end
    else
        print("FAIL: Expected 1 item in inventory, got " .. #mockPlayer.inventory.items)
    end
end

-- Run all tests
function ISLeatherDryingRackTests.runAllTests()
    print("Running Leather Drying Rack Tests...")
    print("=====================================")
    
    ISLeatherDryingRackTests.testLeatherMappingCompleteness()
    ISLeatherDryingRackTests.testLeatherMappingLookup()
    ISLeatherDryingRackTests.testRackTypeDetection()
    ISLeatherDryingRackTests.testRackSizeCompatibility()
    ISLeatherDryingRackTests.testDistanceCalculation()
    ISLeatherDryingRackTests.testWetLeatherDetection()
    ISLeatherDryingRackTests.testLeatherDryingProcess()
    
    print("\n=====================================")
    print("Leather Drying Rack Tests Complete!")
end

-- Auto-run tests if in a standalone Lua environment or debug mode
if _G.getDebug and _G.getDebug() then
    ISLeatherDryingRackTests.runAllTests()
end
