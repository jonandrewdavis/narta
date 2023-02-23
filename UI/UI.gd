extends Node2D

var inventoryManager

@export var clear_inventory:bool = true

@onready var _inv = $UICanvas/Inventory
@onready var _menu = $UICanvas/NartaMenu
@onready var conLabel = $UICanvas/NartaMenu/Control/MarginContainer/VBoxContainer/VBoxContainer/connectedPlayersLabel

@onready var panels = $UICanvas/Weapons/Control/WeaponContainer/WeaponPanels

var connectedPlayers: int = 0
var player = null

# UI includes Inventory logic, like setting & clearing. Only runs on the client.
# The /Inv folder he is just for rendering.
func _ready():
	_prepare_inventory()
	_inv.hide()
	_menu.hide()

func _prepare_inventory() -> void:
	player = get_parent()
	if player == null: return
	print ('DEBUG (LOCAL): _prepare_inventory for name: ', player.name, ' ', get_parent().name)
	if get_tree().get_root().has_node("InventoryManager"):
		inventoryManager = get_tree().get_root().get_node("InventoryManager")
		inventoryManager.player = player
		inventoryManager.clear_inventory(_inv.inventory)

func _on_inventory_button_pressed() -> void:
	if _inv.visible:
		_inv.hide()
	else:
		_inv.show()

func _on_open_menu():
	if (multiplayer.get_peers()): 
		var count = multiplayer.get_peers().size()
		conLabel.text = "Connected players: " + str(count)
	else:
		conLabel.text = "Status: Server Error"
	if _inv.visible:
		_inv.hide()
		return
	if _menu.visible:
		_menu.hide()
	else:
		_menu.show()


func _on_quit_pressed():
	get_tree().quit()
	
func _on_resume_pressed():
	if _menu.visible:
		_menu.hide()

func _on_weapon_picked_up(sprite, index):
	var childPanels = panels.get_children()
	childPanels[index].get_node("TextureRect").texture = sprite

func on_switch_weapon(index):
	var childPanels = panels.get_children()
	for panel in childPanels:
		panel.get_node("ColorRect").visible = false
	childPanels[index].get_node("ColorRect").visible = true

func on_furnace_feed():
	_inv.show()
	if inventoryManager.inventory_has_item_by_name('Narta', 'Coal'):
		inventoryManager.remove_item_by_name('Narta', 'Coal', 1)
		return true
	else:
		return false

func player_drop_inventory():
	print('DROP', inventoryManager.get_inventory_by_name_items())
	pass

func player_clear_inventory():
	inventoryManager.clear_inventory(_inv.inventory)

func _on_check_button_toggled(button_pressed):
	print('passing button pressed', button_pressed )
	player.player_pvp(button_pressed)
	pass # Replace with function body.	
