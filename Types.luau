export type Rarity = "Common" | "Uncommon" | "Rare" | "Epic" | "Legendary" | "Mythic"
export type ItemType = "Boat" | "Rod" | "Fish"

export type Item<T> = {
	name: string,
	description: string,
	rarity: Rarity,
	itemType: ItemType
}

export type BaseItem = {
	name: string,
	description: string,
	rarity: Rarity,
	itemType: ItemType
}

export type Inventory<T> = {[string]: T}

return nil