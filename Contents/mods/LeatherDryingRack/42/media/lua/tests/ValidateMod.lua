-- Simple validation script for leather drying rack mod
-- This can be run in the Project Zomboid debug console

require("LeatherDryingRackData")

print("=== Leather Drying Rack Mod Validation ===")

-- Test leather mapping completeness
local totalInputs = 0
local totalOutputs = 0

for size, data in pairs(LeatherDryingRackData) do
	totalInputs = totalInputs + #data.inputs
	totalOutputs = totalOutputs + #data.outputs

	-- Verify input/output count matches
	if #data.inputs == #data.outputs then
		print("PASS: " .. size .. " leather has " .. #data.inputs .. " inputs/outputs")
	else
		print("FAIL: " .. size .. " leather input/output count mismatch")
	end
end

if totalInputs == 20 then
	print("PASS: All 20 leather types mapped correctly")
else
	print("FAIL: Expected 20 leather types, found " .. totalInputs)
end

-- Test rack type detection
local testRacks = {
	{ name = "Simple_Drying_Rack_1_0", expected = "small" },
	{ name = "Drying_Rack_1_0", expected = "medium" },
	{ name = "Unknown", expected = "medium" },
}

for _, test in ipairs(testRacks) do
	local mockEntity = {
		getName = function()
			return test.name
		end,
	}
	local detected = LeatherDryingRackUtils.getRackType(mockEntity)

	if detected == test.expected then
		print("PASS: " .. test.name .. " → " .. detected)
	else
		print("FAIL: " .. test.name .. " expected " .. test.expected .. ", got " .. detected)
	end
end

print("=== Validation Complete ===")
print("Load this mod and right-click on drying racks with wet leather in inventory!")
