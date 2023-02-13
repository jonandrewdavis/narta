extends Node2D

var inventoryManager

@export var clear_inventory:bool = true

@onready var _inv = $UICanvas/Inventory
@onready var _menu = $UICanvas/NartaMenu
@onready var conLabel = $UICanvas/NartaMenu/Control/MarginContainer/VBoxContainer/VBoxContainer/connectedPlayersLabel

var connectedPlayers: int = 0
var player = null

# UI includes Inventory logic, like setting & clearing. Only runs on the client.
# The /Inv folder he is just for rendering.
func _ready():
	_prepare_inventory()
	_inv.hide()
	_menu.hide()

func _prepare_inventory() -> void:
	if player == null: return
	print ('DEBUG: _prepare_inventory for name: ', player.name)
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
	if OS.is_debug_build():
		_on_quit_pressed()
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
