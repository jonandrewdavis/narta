extends Character

enum {UP, DOWN}

var current_weapon: Node2D

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)

@onready var userlabel = $Label
@onready var parent = get_parent()
@onready var weapons: Node2D = $Weapons
@onready var interactArea: Area2D = $InteractArea

var UI = preload("res://UI/UI.tscn")
var UIref = null

var mouse_direction: Vector2

const PLAYER_MAX_CONST = 80
const RESPAWN_RADIUS = 75
var PLAYER_START: Vector2 = Vector2(-950, 10)

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	# NOTE: This `not is_multiplayer_authority()` check 
	# assures that code runs only on the client.
	# All nodes within these are LOCAL only. Camera, Inventory, UI, etc.
	# TODO: Move `userlabel.text` above this line and remove from sync
	if not is_multiplayer_authority(): return
	var newCamera = Camera2D.new()
	var newUI = UI.instantiate()
	userlabel.text = SavedData.username
	# All local. Weapons are in /Weapons, so those exist on server, and need to.
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	newCamera.ignore_rotation = true
	newCamera.limit_smoothed = true
	add_child(newCamera)
	add_child(newUI)
	UIref = get_node("UI")
	_restore_previous_state()
	
func is_player():
	return true

func _restore_previous_state() -> void:
	max_hp = 5
	hp = 5
	max_speed = PLAYER_MAX_CONST
	if self.name == str(1):
		PLAYER_START = Vector2.ZERO
	if randi() % 2 == 0:
		position = Vector2(PLAYER_START.x + randf() * RESPAWN_RADIUS, PLAYER_START.y + randf() * RESPAWN_RADIUS)
	else: 
		position = Vector2(PLAYER_START.x - randf() * RESPAWN_RADIUS, PLAYER_START.y - randf() * RESPAWN_RADIUS)
	state_machine.set_state(state_machine.states.idle)
	_update_health_bar()
	if UIref != null:
		UIref.player_clear_inventory()
	
	var i = 0
	for weapon in weapons.get_children():
		weapon.hide()
		emit_signal("weapon_picked_up", )
		emit_signal("weapon_switched", weapons.get_child_count() - 2, weapons.get_child_count() - 1)
		if UIref != null:
			UIref._on_weapon_picked_up(weapon.get_texture(), i)
		i += 1
		
	current_weapon = weapons.get_child(0)
	if UIref != null:
		UIref.on_switch_weapon(0)
	current_weapon.show()
	
	emit_signal("weapon_switched", weapons.get_child_count() - 1, SavedData.equipped_weapon_index)
	

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	
	mouse_direction = (get_global_mouse_position() - global_position).normalized()
	
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
		
	current_weapon.move(mouse_direction)


func _unhandled_input(_event):
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("inventory"):
		UIref._on_inventory_button_pressed()
		return
	if Input.is_action_just_pressed("ui_escape"):
		UIref._on_open_menu()
	if Input.is_action_just_pressed("interact"):
		interact()

func get_input() -> void:
	if not is_multiplayer_authority(): return
		
	mov_direction = Vector2.ZERO
	mov_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	mov_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	mov_direction = mov_direction.normalized()
	
	# NOTE: DO NOT USE
	# This can add some mouse control over the player, but it's jarring when
	# you are used WASD being the exclusive determinator. Better to modulate speed.
	#if current_weapon.is_busy():
	#	mov_direction =	mov_direction + mouse_direction / 4
	
	if not current_weapon.is_busy():
		if Input.is_action_just_released("one"):
			change_weapon(0)
		elif Input.is_action_just_released("two"):
			change_weapon(1)
		elif Input.is_action_just_released("three"):
			change_weapon(2)
		# elif Input.is_action_just_released("four"):
			# change_weapon(3)
		# elif Input.is_action_just_released("five"):
			# change_weapon(4)
		
	current_weapon.get_input()
	
	
func _switch_weapon(direction: int) -> void:
	var prev_index: int = current_weapon.get_index()
	var index: int = prev_index
	if direction == UP:
		index -= 1
		if index < 0:
			index = weapons.get_child_count() - 1
	else:
		index += 1
		if index > weapons.get_child_count() - 1:
			index = 0
			
	current_weapon.hide()
	current_weapon = weapons.get_child(index)
	current_weapon.show()
	SavedData.equipped_weapon_index = index
	
	UIref.on_switch_weapon(index)
	
	emit_signal("weapon_switched", prev_index, index)

func change_weapon(new_index):
	var prev_index: int = current_weapon.get_index()
	var index: int = new_index
	if index != prev_index:
		current_weapon = weapons.get_child(index)
		current_weapon.show()	
		UIref.on_switch_weapon(index)
		emit_signal("weapon_switched", prev_index, index)
	
func pick_up_weapon(weapon: Node2D) -> void:
	SavedData.weapons.append(weapon.duplicate())
	var prev_index: int = SavedData.equipped_weapon_index
	var new_index: int = weapons.get_child_count()
	SavedData.equipped_weapon_index = new_index
	weapon.get_parent().call_deferred("remove_child", weapon)
	weapons.call_deferred("add_child", weapon)
	weapon.set_deferred("owner", weapons)
	current_weapon.hide()
	current_weapon.cancel_attack()
	current_weapon = weapon
	
	emit_signal("weapon_picked_up", weapon.get_texture())
	emit_signal("weapon_switched", prev_index, new_index)
	
	
func _drop_weapon() -> void:
	SavedData.weapons.remove_at(current_weapon.get_index() - 1)
	var weapon_to_drop: Node2D = current_weapon
	_switch_weapon(UP)
	
	emit_signal("weapon_droped", weapon_to_drop.get_index())
	
	weapons.call_deferred("remove_child", weapon_to_drop)
	get_parent().call_deferred("add_child", weapon_to_drop)
	weapon_to_drop.set_owner(get_parent())
	weapon_to_drop.show()
	
	# var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	# weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
		
		
func cancel_attack() -> void:
	pass
#	current_weapon.cancel_attack()
	
func respawn() -> void:
	_restore_previous_state()


func interact(): 
	# Look for interactable bodies,
	# pick closest
	var objs = interactArea.get_overlapping_areas()
	if objs.size() > 0:
		if objs[0].get_parent().has_method('on_interact'):
			objs[0].get_parent().on_interact(self)

# TODO: This should be emit, (signal up)
func player_pvp(value):
	self.set_collision_layer_value(6, value)
	print('player layer',self.get_collision_layer_value(6))
	for weapon in weapons.get_children():
		weapon.toggle_pvp(value)


func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.dead and state_machine.state != state_machine.states.hurt:
		hp -= dam
		velocity += dir * force
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
		else:
			state_machine.set_state(state_machine.states.dead)
		_spawn_hit_effect()
		_update_health_bar()
