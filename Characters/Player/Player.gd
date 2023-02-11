extends Character

enum {UP, DOWN}

var current_weapon: Node2D

signal weapon_switched(prev_index, new_index)
signal weapon_picked_up(weapon_texture)
signal weapon_droped(index)

@onready var userlabel = $Label
@onready var parent: Node2D = get_parent()
@onready var weapons: Node2D = $Weapons

var UI = preload("res://UI/UI.tscn")
var UIref = null

var mouse_direction: Vector2

const RESPAWN_RADIUS = 200

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	var newCamera = Camera2D.new()
	var newUI = UI.instantiate()
	emit_signal("weapon_picked_up", weapons.get_child(0).get_texture())
	userlabel.text = SavedData.username		
	_restore_previous_state()
	newCamera.ignore_rotation = true
	newCamera.limit_smoothed = true
	add_child(newCamera)
	newUI.player = self
	add_child(newUI)
	UIref = newUI
	
func is_player():
	return true

func _restore_previous_state() -> void:
	max_speed = 100
	max_hp = 5
	hp = 5
	if randi() / 2 == 0:
		position = Vector2(0 + randf() * RESPAWN_RADIUS, 0 + randf() * RESPAWN_RADIUS)
	else: 
		position = Vector2(0 - randf() * RESPAWN_RADIUS, 0 - randf() * RESPAWN_RADIUS)
	state_machine.set_state(state_machine.states.idle)
	_update_health_bar()
	
	for weapon in SavedData.weapons:
		weapon = weapon.duplicate()
		weapon.position = Vector2.ZERO
		weapons.add_child(weapon)
		weapon.hide()
		
		emit_signal("weapon_picked_up", weapon.get_texture())
		emit_signal("weapon_switched", weapons.get_child_count() - 2, weapons.get_child_count() - 1)
		
	current_weapon = weapons.get_child(SavedData.equipped_weapon_index)
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


func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("inventory"):
		print(UIref)
		UIref._on_inventory_button_pressed()
		return
	if Input.is_action_just_pressed("ui_escape"):
		get_tree().quit()


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
		if Input.is_action_just_released("ui_previous_weapon"):
			_switch_weapon(UP)
		elif Input.is_action_just_released("ui_next_weapon"):
			_switch_weapon(DOWN)
		elif Input.is_action_just_pressed("attack3") and current_weapon.get_index() != 0:
			_drop_weapon()
		
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
	await weapon_to_drop.tween.tree_entered
	weapon_to_drop.show()
	
	var throw_dir: Vector2 = (get_global_mouse_position() - position).normalized()
	weapon_to_drop.interpolate_pos(position, position + throw_dir * 50)
		
		
func cancel_attack() -> void:
	pass
	# current_weapon.cancel_attack()
	
func respawn() -> void:
	_restore_previous_state()
