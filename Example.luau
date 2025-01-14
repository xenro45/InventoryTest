local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local systemMessage = ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("systemMessage")
local InventoryController = require(ServerScriptService.Classes.InventoryController)
local Rarity = require(ReplicatedStorage.Enums.Rarity)
local ItemTypes = require(ReplicatedStorage.Enums.ItemTypes)
local Types = require(ReplicatedStorage.Types)


local function onPlayerJoin(player: Player)
	systemMessage:FireAllClients(`{player} joined the session`)
	local Inventory = InventoryController.new(player)
    Inventory.debugMessages = true
    Inventory:appendItem("Broken Fishing Rod")
    Inventory:appendItem("Trout")
    Inventory:appendItem("Row Boat")
    
    Inventory:removeItem(Inventory:findByBlueprint("Trout"))
    Inventory:reviseItem(Inventory:findByBlueprint("RowBoat"), {rarity = Rarity.Rare})
end

local function onPlayerLeave(player: Player)
	systemMessage:FireAllClients(`{player} left the session`)
end

Players.PlayerRemoving:Connect(onPlayerLeave)
Players.PlayerAdded:Connect(onPlayerJoin)