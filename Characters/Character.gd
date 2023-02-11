class_name Character
extends CharacterBody2D

const HIT_EFFECT_SCENE: PackedScene = preload("res://Characters/HitEffect.tscn")

@export var max_hp: int = 3
@export var hp: int = 3 
@export var FRICTION: int = 500
@export var acceleration = 500
@export var max_speed = 100
@export var flying: bool = false

@onready var state_machine: Node = get_node("FiniteStateMachine")
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var health_bar = $HealthBar
@onready var mov_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if mov_direction != Vector2.ZERO && acceleration != null:
		velocity = velocity.move_toward(mov_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

# Decides during the state if it's a move state.
# TODO: Remove max speed from sync and use this to stop movement.
# Server can gradually increase max speed. 
func move() -> void:
	pass

# signals go to PVE enemies
# the rest are used client side for players, etc.
@rpc("any_peer")
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		hp -= dam
		velocity += dir * force
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
		else:
			state_machine.set_state(state_machine.states.dead)
		_spawn_hit_effect()		
		_update_health_bar()

func take_knockback(dam: int, dir: Vector2, force: int) -> void:
		velocity += dir * force

func _spawn_hit_effect() -> void:
	var hit_effect: Sprite2D = HIT_EFFECT_SCENE.instantiate()
	add_child(hit_effect)

func _update_health_bar(): 
	health_bar.visible = hp < max_hp
	health_bar.value = hp
	health_bar.max_value = max_hp
