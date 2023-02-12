extends Node2D

var inventoryManager

@export var clear_inventory:bool = true

#@onready var _error_ui = $CanvasError as CanvasLayer
@onready var _inv = $UICanvas/Inventory
# @onready var _inventory_button_ui = $CanvasButton/TextureButton as TextureButton
@onready var _menu = $UICanvas/NartaMenu
@onready var conLabel = $UICanvas/NartaMenu/Control/MarginContainer/VBoxContainer/VBoxContainer/connectedPlayersLabel

var connectedPlayers: int = 0
var player = null

func _enter_tree():
	set_multiplayer_authority(str(player.name).to_int())

func _ready():
	_prepare_inventory()
	_inv.hide()
	_menu.hide()

func _prepare_inventory() -> void:
	if player == null: return
	if get_tree().get_root().has_node("InventoryManager"):
#		_error_ui.queue_free()
		inventoryManager = get_tree().get_root().get_node("InventoryManager")
		inventoryManager.player = player
		inventoryManager.clear_inventory(_inv.inventory)
		# _inventory_button_ui.pressed.connect(_on_inventory_button_pressed)
		

func _on_inventory_button_pressed() -> void:
	if _inv.visible:
		_inv.hide()
	else:
		_inv.show()


func _on_open_menu():
	#if OS.is_debug_build():
	#	_on_quit_pressed()
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
