local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Inventory = require(ReplicatedStorage.Data.Inventory)
local Events = ReplicatedStorage:FindFirstChild("Events")
local CurrentInventoryIndex = require(ReplicatedStorage.Data.CurrentInventoryIndex)
local blueprints = require(ServerScriptService.Blueprints)

local Types = require(ReplicatedStorage.Types)

local InventoryController = {}
InventoryController.__index = InventoryController

function InventoryController.new(player: Player)
	local self = setmetatable({
		player = player,
		debugMessages = false,
		_loaded = Instance.new("BindableEvent"),
	}, InventoryController)
	self.loaded = self._loaded.Event
	repeat task.wait() until Inventory:isLoaded(self.player)
	task.delay(0, function()
		self._loaded:Fire()
	end)
	return self
end

--appends an item to the players data from a blueprint
function InventoryController:appendItem<T>(bp: string, amount: number?): string
	local itemData: T = blueprints[bp]
	assert(itemData, `{bp} has no associated data`)
	amount = amount or 1
	local currentInventory = self:read()
	local newInventory = table.clone(currentInventory)
	
	local guids = {}
	for i = 1, amount do 
		local guid = HttpService:GenerateGUID(false)
		newInventory[guid] = itemData
		table.insert(guids, guid)
	end
	
	self:_write(newInventory)
	
	if self.debugMessages then
		warn(newInventory)
	end
	
	if amount > 1 then 
		return guids
	else
		return guids[1]
	end
end

--modifies a given items data
function InventoryController:reviseItem<T>(guid: string, newData: {any}): nil
	local currentInventory = self:read()
	local newInventory = table.clone(currentInventory)
	local targetItem: T = newInventory[guid]
	assert(targetItem, `{guid} has no associated data`)
	
	for i, v in pairs(newData) do
		targetItem[i] = v
	end
	
	newInventory[guid] = targetItem
	
	self:_write(newInventory)
end

--completly removes an item from the players inventory
function InventoryController:removeItem(guid: string): nil
	local currentInventory = self:read()
	assert(currentInventory[guid], `{guid} has no associated data`)
	local newInventory = table.clone(currentInventory)
	newInventory[guid] = nil
	self:_write(newInventory)
end

--finds the guid (Key) of any item that matches the blueprint
function InventoryController:findByBlueprint(bp: string): {string}
	assert(blueprints[bp], `{bp} has no blueprint`)
	local currentInventory = self:read()
	local guidList = {}
	for i, v in currentInventory do 
		if v == blueprints[bp] then
			table.insert(guidList, i)
		end
	end
	return guidList
end

--allows for filtering items out via specific value
function InventoryController:findByPrecise<T>(itemType: Types.ItemType, name: string, rarity: Types.Rarity): {string}
	local currentInventory = self:read()
	local guidList = {}
	
	for i, v:T in currentInventory do
		if v.itemType == itemType and v.name == name and v.rarity == rarity then
			table.insert(guidList, i)
		end
	end
	return guidList
end

--returns the raw data of a stored item
function InventoryController:getItemByGuid<T>(guid: string): T
	local currentInventory = self:read()
	assert(currentInventory[guid], `{guid} not found in inventory`)
	return currentInventory[guid]
end

--returns the entire inventory table
function InventoryController:read<T>(): Types.Inventory<T>
	return Inventory:getFor(self.player)
end

--writes to the inventory table
function InventoryController:_write<T>(data: Types.Inventory<T>): nil
	Inventory:setFor(self.player, data)
end

--cleaning up
function InventoryController:_cleanUp(): nil
	self._loaded:Destroy()
	setmetatable(InventoryController, nil)
end

return InventoryController