# NARTA, CUSTOM EDIT!!!!

# Item2D as custom type for InventoryEditor : MIT License
# @author Vladimir Petrenko
@tool
extends Node2D
class_name Item2D

var inside 
var _inventoryManager
const InventoryManagerName = "InventoryManager"
var questManager
const questManagerName = "QuestManager"

@export var item_put: String # item_uuid 
@export var to_inventory: String # inventory_uuid
@export var quantity: int = 1
@export var remove_collected: bool = true
@export var autosave: bool = true

func _ready() -> void:
	if get_tree().get_root().has_node(InventoryManagerName):
		_inventoryManager = get_tree().get_root().get_node(InventoryManagerName)
		if has_node("InventoryItem_" + item_put + "/Area2D"):
			var area = get_node("InventoryItem_" + item_put + "/Area2D")
			if not area.body_entered.is_connected(_on_body_entered):
				assert(area.body_entered.connect(_on_body_entered) == OK)
			if not area.body_exited.is_connected(_on_body_exited):
				assert(area.body_exited.connect(_on_body_exited) == OK)
	if get_tree().get_root().has_node(questManagerName):
		questManager = get_tree().get_root().get_node(questManagerName)

func _on_body_entered(body: Node) -> void:
	if not body.has_method('is_player'):
		return
	# NOTE: This is the multiplayer check!!!
	# The way this works is that all players see a 'puppet' that makes contact.
	# EVERYONE gets an item. 
	# Only trigger the gather if the Player multiplayer 'name' matches ==
	# This is a shortcut to run on only on the client.
	if body.name == _inventoryManager.player.name:
		_on_local_gather()
	inside = true
	var remainder = 0
	if remove_collected and remainder == 0:
		queue_free()
		if questManager and questManager.is_quest_started():
			var quest = questManager.started_quest()
			var task = questManager.get_task_and_update_quest_state(quest, item_put, quantity, autosave)

func _on_local_gather():
	_inventoryManager.add_item(to_inventory, item_put, quantity)
	
func _on_body_exited(body: Node) -> void:
	inside = false

func _process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	if Engine.is_editor_hint() and item_put != null and not item_put.is_empty():
		if not has_node("InventoryItem_" + item_put):
			_remove_old_childs()
			if not get_tree().edited_scene_root.has_node(InventoryManagerName):
				var root = get_tree().edited_scene_root
				var manager = Node2D.new()
				manager.name = InventoryManagerName
				manager.set_script(load("res://addons/inventory_editor/InventoryManager.gd"))
				# NOTE: 
				# We're adding 'true' to add_child calls to help with networkning errors like 
				# ANND: fixed the bug!! true here and to the add_child below!!
				# E 0:00:21:0547   on_spawn_receive: Condition "parent->has_node(name)" is true. Returning: ERR_INVALID_DATA
				root.add_child(manager, true)
				manager.set_owner(get_tree().edited_scene_root)
				var item_db = manager.get_item_db(item_put)
				if item_db and not item_db.scene.is_empty():
					var scene = load(item_db.scene).instantiate()
					if scene:
						scene.name = "InventoryItem_" + item_db.uuid
						add_child(scene, true)
						scene.set_owner(get_tree().edited_scene_root)
				root.remove_child(manager)
				manager.queue_free()

func _remove_old_childs() -> void:
	for child in get_children():
		if str(child.name).begins_with("InventoryItem_"):
			remove_child(child)
			child.queue_free()
