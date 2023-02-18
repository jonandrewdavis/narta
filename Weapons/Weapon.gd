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
	pass

func get_input() -> void:
	pass

func move(_mouse_direction: Vector2) -> void:
	pass

func cancel_attack() -> void:
	pass
	
	
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


func apply_slow():
	playerBody.max_speed = playerBody.max_speed / 3

func remove_slow():
	playerBody.max_speed = playerBody.PLAYER_MAX_CONST
	
