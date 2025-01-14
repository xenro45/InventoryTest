local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rarity = require(ReplicatedStorage.Enums.Rarity)
local ItemTypes = require(ReplicatedStorage.Enums.ItemTypes)
local Types = require(ReplicatedStorage.Types)

return {
	["Broken Fishing Rod"] = {
		name = "Broken fishing rod",
		description = "fishing rod",
		rarity = Rarity.Common,
		itemType = ItemTypes.Rod
	}:: Types.Item,
	["Trout"] = {
		name = "Trout",
		description = "Trout",
		rarity = Rarity.Uncommon,
		itemType = ItemTypes.Fish
	}:: Types.Item,
	["Row Boat"] = {
		name = "Row Boat",
		description = "a simple row boat",
		rarity = Rarity.Rare,
		itemType = ItemTypes.Boat
	}
}:: Types.Inventory