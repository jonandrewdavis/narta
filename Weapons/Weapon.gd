extends Node2D
class_name Weapon

@export var on_floor: bool = false

@export var ranged_weapon: bool = false
@export var rotation_offset: int = 0

var can_active_ability: bool = true

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var hitbox: Area2D = get_node("Node2D/Sprite2D/Hitbox")
@onready var charge_particles: GPUParticles2D = get_node("Node2D/ChargeParticles")
@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var cool_down_timer: Timer = get_node("CoolDownTimer")
@onready var playerBody: CharacterBody2D = get_parent().get_parent();

func _ready() -> void:
	if not on_floor:
		# player_detector.set_collision_mask_value(0, false)
		player_detector.set_collision_mask_value(1, false)
	hitbox.knockback_force = 215

# TODO: Force & Damage on animations, to remove them from weapons generics... easier here for now
func get_input() -> void:
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("attack") and not animation_player.is_playing():
		playerBody.max_speed = 35
		animation_player.play("SwordBase/charge")
	elif Input.is_action_just_released("attack"):
		playerBody.max_speed = 100		
		if animation_player.is_playing() and animation_player.current_animation == "SwordBase/charge":
			hitbox.knockback_force = 215
			animation_player.play("SwordBase/attack")
		elif charge_particles.emitting:
			hitbox.knockback_force = 280
			animation_player.play("SwordBase/strong_attack")
	elif Input.is_action_just_pressed("attack3") and animation_player.has_animation("SwordBase/active_ability") and not is_busy() and can_active_ability:
		can_active_ability = false
		cool_down_timer.start()
		animation_player.play("SwordBase/active_ability")
			
			
func move(mouse_direction: Vector2) -> void:
	if not is_multiplayer_authority(): return
	
	if ranged_weapon:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		if not animation_player.is_playing() or animation_player.current_animation == "SwordBase/charge":
			rotation = mouse_direction.angle()
			hitbox.knockback_direction = mouse_direction
			if scale.y == 1 and mouse_direction.x < 0:
				scale.y = -1
			elif scale.y == -1 and mouse_direction.x > 0:
				scale.y = 1
			
			
func cancel_attack() -> void:
	animation_player.play("SwordBase/cancel_attack")
	
	
func is_busy() -> bool:
	if animation_player.is_playing() or charge_particles.emitting:
		return true
	return false


func _on_PlayerDetector_body_entered(body: CharacterBody2D) -> void:
	if body != null:
		player_detector.set_collision_mask_value(0, false)
		player_detector.set_collision_mask_value(1, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		player_detector.set_collision_mask_value(1, true)
		
		
func interpolate_pos(_initial_pos: Vector2, _final_pos: Vector2) -> void:
	pass

func _on_CoolDownTimer_timeout() -> void:
	can_active_ability = true
	
func get_texture() -> Texture2D:
	return get_node("Node2D/Sprite2D").texture
