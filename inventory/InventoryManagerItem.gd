# List of creted items for InventoryManger to use in source code: MIT License
# @author Vladimir Petrenko
@tool
class_name InventoryManagerItem


enum ItemEnum { NONE,  HealthNormal, HealthBig, ManaNormal, ManaBig, HealthNormal3D, HealthBig3D, ManaNormal3D, ManaBig3D, SwordDestroyer, SwordDragonhunter, SwordDestroyer3D, SwordDragonhunter3D, HelmetKnight, HelmetViking, ArmorKnight, ArmorViking, GlovesLeftKnight, GlovesLeftViking, GlovesRightKnight, GlovesRightViking, BootsKnight, BootsViking, ShieldKnight, ShieldViking, Gold2D, Metal2D, Horn2D, Coal, IronOre, PlayerScrap, RecipeHelmetKnight2D, RecipeHelmetViking2D}

const HEALTHNORMAL = "f4352b3f-8500-419f-9617-9da134d822f5"
const HEALTHBIG = "63015407-55c9-4729-887f-493fe2a624b7"
const MANANORMAL = "af0ab25b-4add-4834-ad96-555efd2e629d"
const MANABIG = "a9f24ca6-b213-4f07-a690-2185ffd6ec1d"
const HEALTHNORMAL3D = "84993f8a-a25d-48f2-8a90-975f79f8995d"
const HEALTHBIG3D = "f2d2172d-9c78-4b5a-bd50-710cb914e578"
const MANANORMAL3D = "5a340c0a-19f0-4827-ad81-d0cfbab5c575"
const MANABIG3D = "5e7ebf21-abad-4c18-bce7-915ae9e57a31"
const SWORDDESTROYER = "cf240703-26ac-4a2a-88a7-1441ff6c6a0c"
const SWORDDRAGONHUNTER = "5fa70d8d-c0d0-43d9-8260-6efa4fde008b"
const SWORDDESTROYER3D = "52d0a7fa-b133-45f1-9b75-b9818c8599d2"
const SWORDDRAGONHUNTER3D = "38a142cc-57cb-4f07-8e61-3b7c6601f3b8"
const HELMETKNIGHT = "8274191e-eaac-4605-9f3e-f55492b5a4b9"
const HELMETVIKING = "a20c35ce-bcc8-4344-9840-dc0783ebb2e4"
const ARMORKNIGHT = "677586f9-55cc-40c2-bd87-7c54430c629d"
const ARMORVIKING = "3b6f1acc-6616-4af8-aba3-0fe78c57da13"
const GLOVESLEFTKNIGHT = "8d1e1f40-99d4-4054-9891-af6342dab146"
const GLOVESLEFTVIKING = "4f73839a-9671-4ff0-94f7-8db09d3566a2"
const GLOVESRIGHTKNIGHT = "a71930cb-0732-4420-a182-7bbfd93b3d21"
const GLOVESRIGHTVIKING = "bf6722f3-fbeb-4929-904c-511daa8b120b"
const BOOTSKNIGHT = "e4b10f53-f1ef-437d-9d19-f877e7a7075c"
const BOOTSVIKING = "04c54b13-060a-452b-a5df-96b49d276cb1"
const SHIELDKNIGHT = "9802268f-f635-4469-8c6a-b12f0720da6a"
const SHIELDVIKING = "921213e4-4daf-4221-809b-2bfe4a69ccf1"
const GOLD2D = "f468cddf-638f-4b2f-9147-a1ceaa0f5c53"
const METAL2D = "424be528-8960-4c74-a96f-229724ebd870"
const HORN2D = "bbbbfd43-1f98-4b1a-bf3e-9f7383204803"
const COAL = "c9054497-3242-4056-8230-a21d891c916f"
const IRONORE = "b913e55a-3bab-4a28-8886-45881f3ce486"
const PLAYERSCRAP = "9d19ecd4-3f7b-49ed-b548-e187db92e4cc"
const RECIPEHELMETKNIGHT2D = "97b7c8ba-3c27-4158-9633-11dbd4fefd21"
const RECIPEHELMETVIKING2D = "73cbb965-26a5-4867-9849-9909c096641f"

const ITEMS = [
 "HealthNormal",
 "HealthBig",
 "ManaNormal",
 "ManaBig",
 "HealthNormal3D",
 "HealthBig3D",
 "ManaNormal3D",
 "ManaBig3D",
 "SwordDestroyer",
 "SwordDragonhunter",
 "SwordDestroyer3D",
 "SwordDragonhunter3D",
 "HelmetKnight",
 "HelmetViking",
 "ArmorKnight",
 "ArmorViking",
 "GlovesLeftKnight",
 "GlovesLeftViking",
 "GlovesRightKnight",
 "GlovesRightViking",
 "BootsKnight",
 "BootsViking",
 "ShieldKnight",
 "ShieldViking",
 "Gold2D",
 "Metal2D",
 "Horn2D",
 "Coal",
 "IronOre",
 "PlayerScrap",
 "RecipeHelmetKnight2D",
 "RecipeHelmetViking2D"
]

static func item_by_enum(item_enum: ItemEnum) -> String:
	match item_enum:
		ItemEnum.HealthNormal:
			return InventoryManagerItem.HEALTHNORMAL
		ItemEnum.HealthBig:
			return InventoryManagerItem.HEALTHBIG
		ItemEnum.ManaNormal:
			return InventoryManagerItem.MANANORMAL
		ItemEnum.ManaBig:
			return InventoryManagerItem.MANABIG
		ItemEnum.HealthNormal3D:
			return InventoryManagerItem.HEALTHNORMAL3D
		ItemEnum.HealthBig3D:
			return InventoryManagerItem.HEALTHBIG3D
		ItemEnum.ManaNormal3D:
			return InventoryManagerItem.MANANORMAL3D
		ItemEnum.ManaBig3D:
			return InventoryManagerItem.MANABIG3D
		ItemEnum.SwordDestroyer:
			return InventoryManagerItem.SWORDDESTROYER
		ItemEnum.SwordDragonhunter:
			return InventoryManagerItem.SWORDDRAGONHUNTER
		ItemEnum.SwordDestroyer3D:
			return InventoryManagerItem.SWORDDESTROYER3D
		ItemEnum.SwordDragonhunter3D:
			return InventoryManagerItem.SWORDDRAGONHUNTER3D
		ItemEnum.HelmetKnight:
			return InventoryManagerItem.HELMETKNIGHT
		ItemEnum.HelmetViking:
			return InventoryManagerItem.HELMETVIKING
		ItemEnum.ArmorKnight:
			return InventoryManagerItem.ARMORKNIGHT
		ItemEnum.ArmorViking:
			return InventoryManagerItem.ARMORVIKING
		ItemEnum.GlovesLeftKnight:
			return InventoryManagerItem.GLOVESLEFTKNIGHT
		ItemEnum.GlovesLeftViking:
			return InventoryManagerItem.GLOVESLEFTVIKING
		ItemEnum.GlovesRightKnight:
			return InventoryManagerItem.GLOVESRIGHTKNIGHT
		ItemEnum.GlovesRightViking:
			return InventoryManagerItem.GLOVESRIGHTVIKING
		ItemEnum.BootsKnight:
			return InventoryManagerItem.BOOTSKNIGHT
		ItemEnum.BootsViking:
			return InventoryManagerItem.BOOTSVIKING
		ItemEnum.ShieldKnight:
			return InventoryManagerItem.SHIELDKNIGHT
		ItemEnum.ShieldViking:
			return InventoryManagerItem.SHIELDVIKING
		ItemEnum.Gold2D:
			return InventoryManagerItem.GOLD2D
		ItemEnum.Metal2D:
			return InventoryManagerItem.METAL2D
		ItemEnum.Horn2D:
			return InventoryManagerItem.HORN2D
		ItemEnum.Coal:
			return InventoryManagerItem.COAL
		ItemEnum.IronOre:
			return InventoryManagerItem.IRONORE
		ItemEnum.PlayerScrap:
			return InventoryManagerItem.PLAYERSCRAP
		ItemEnum.RecipeHelmetKnight2D:
			return InventoryManagerItem.RECIPEHELMETKNIGHT2D
		ItemEnum.RecipeHelmetViking2D:
			return InventoryManagerItem.RECIPEHELMETVIKING2D
		_:
			return ""
