---@meta
---@meta

-- Import Umbrella types for Project Zomboid API
require "ISUI/ISContextMenu"
require "LeatherDryingRackData"

---@class ISLeatherDryingRackMenu
ISLeatherDryingRackMenu = {}

-- Determine rack type based on entity name
---@param entity IsoObject
---@return string rackType
function ISLeatherDryingRackMenu.getRackType(entity)
	return LeatherDryingRackUtils.getRackType(entity)
end

-- Get compatible leather sizes for rack type
---@param rackType string
---@return table compatibleSizes
function ISLeatherDryingRackMenu.getCompatibleSizes(rackType)
	return LeatherDryingRackUtils.getCompatibleSizes(rackType)
end

-- Check if player is within interaction distance of rack
---@param player IsoPlayer
---@param rack IsoObject
---@return boolean isNear
function ISLeatherDryingRackMenu.isPlayerNearRack(player, rack)
	return LeatherDryingRackUtils.isPlayerNearRack(player, rack)
end

-- Get wet leather items from player inventory
---@param player IsoPlayer
---@return table wetLeatherItems
function ISLeatherDryingRackMenu.getWetLeatherItems(player)
	return LeatherDryingRackUtils.getWetLeatherItems(player)
end

-- Perform leather drying
---@param player IsoPlayer
---@param wetLeatherData table
---@param rack IsoObject
function ISLeatherDryingRackMenu.dryLeather(player, wetLeatherData, rack)
	local inventory = player:getInventory()
	local wetItem = wetLeatherData.item
	
	-- Remove wet leather from inventory
	inventory:Remove(wetItem)
	
	-- Add dried leather to inventory
	local driedItem = inventory:AddItem(wetLeatherData.outputType)
	
	-- Sync for multiplayer
	if sendAddItemToContainer then
		sendAddItemToContainer(inventory, driedItem)
	end
	
	-- Show feedback message
	if player.Say then
		player:Say("Dried " .. wetItem:getDisplayName() .. " on " .. rack:getDisplayName())
	end
end

-- Main context menu handler
---@param player number
---@param context ISContextMenu
---@param worldobjects table
---@param test boolean
function ISLeatherDryingRackMenu.OnFillWorldObjectContextMenu(player, context, worldobjects, test)
	if test and ISWorldObjectContextMenu.Test then return true end

	local playerObj = getSpecificPlayer(player)
	if not playerObj then return end
	
	if playerObj:getVehicle() then return false end

	-- Find drying rack objects
	local dryingRacks = {}
	for i, obj in ipairs(worldobjects) do
		if instanceof(obj, "IsoThumpable") then
			local name = obj:getName()
			if name and (string.find(name, "Drying_Rack") or string.find(name, "Herb_Drying_Rack")) then
				table.insert(dryingRacks, obj)
			end
		end
	end
	
	if #dryingRacks == 0 then return end

	-- Get wet leather items from player inventory
	local wetLeatherItems = ISLeatherDryingRackMenu.getWetLeatherItems(playerObj)
	if #wetLeatherItems == 0 then return end

	-- Process each drying rack
	for _, rack in ipairs(dryingRacks) do
		if not ISLeatherDryingRackMenu.isPlayerNearRack(playerObj, rack) then
			-- skip this rack
		else
			local rackType = ISLeatherDryingRackMenu.getRackType(rack)
			local compatibleSizes = ISLeatherDryingRackMenu.getCompatibleSizes(rackType)
			
			-- Create main option for this rack
			local rackOption = context:addOptionOnTop("Dry Leather on " .. rack:getDisplayName(), worldobjects, nil)
			local subMenu = ISContextMenu:getNew(context)
			context:addSubMenu(rackOption, subMenu)
			
			local hasCompatibleLeather = false
			
			-- Add compatible leather options
			for _, leatherData in ipairs(wetLeatherItems) do
				if compatibleSizes[leatherData.size] then
					hasCompatibleLeather = true
					local option = subMenu:addOption(
						"Dry " .. leatherData.item:getDisplayName(),
						rack,
						ISLeatherDryingRackMenu.dryLeather,
						playerObj,
						leatherData,
						rack
					)
					
					-- Add tooltip with leather info
					option.toolTip = ISWorldObjectContextMenu.addToolTip()
					option.toolTip:setName("Dry Leather")
					option.toolTip.description = "Transforms wet furred leather into dried leather using this drying rack.\\n\\nInput: " .. 
						leatherData.item:getDisplayName() .. "\\nOutput: " .. 
						leatherData.item:getDisplayName():gsub("Wet", "Dried") .. 
						"\\n\\nRack Type: " .. rackType:gsub("^%l", string.upper)
				else
					-- Add disabled option with explanation
					local option = subMenu:addOption(
						leatherData.item:getDisplayName() .. " (Rack too small)",
						rack,
						nil,
						playerObj,
						leatherData,
						rack
					)
					option.notAvailable = true
					option.toolTip = ISWorldObjectContextMenu.addToolTip()
					option.toolTip:setName("Rack Too Small")
					option.toolTip.description = "This leather requires a " .. leatherData.size .. " drying rack, but this is a " .. rackType .. " rack."
				end
			end
			
			if not hasCompatibleLeather then
				local noCompatibleOption = subMenu:addOption("No compatible leather for this rack", rack, nil)
				noCompatibleOption.notAvailable = true
			end
		end
	end
end

-- Register to event handler
if Events and Events.OnFillWorldObjectContextMenu then
	Events.OnFillWorldObjectContextMenu.Add(ISLeatherDryingRackMenu.OnFillWorldObjectContextMenu)
end
