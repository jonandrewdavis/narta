extends CharacterBody2D
class_name Character

# TODO: Should Enemy extend this at all. 
# TODO: Hit effect should be packed with a lot of effects.
const HIT_EFFECT_SCENE: PackedScene = preload("res://Characters/HitEffect.tscn")

@export var max_hp: int = 3
@export var hp: int = 3 
@export var FRICTION: int = 500
@export var acceleration = 500
@export var max_speed = 100
@export var flying: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: Node = get_node("FiniteStateMachine")
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var health_bar = $HealthBar
@onready var mov_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if mov_direction != Vector2.ZERO:
		velocity = velocity.move_toward(mov_direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func move() -> void:
	move_and_slide()

# take_damage drives a lot of logic
# source is from HitBox on enemies or on weapon
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.dead:
		hp -= dam
		velocity += dir * force
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
		else:
			state_machine.set_state(state_machine.states.dead)
		_spawn_hit_effect()
		_update_health_bar()

func take_knockback(_dam: int, dir: Vector2, force: int) -> void:
		velocity += dir * force

func _spawn_hit_effect() -> void:
	var hit_effect: Sprite2D = HIT_EFFECT_SCENE.instantiate()
	add_child(hit_effect, true)

func _update_health_bar(): 
	health_bar.visible = hp < max_hp
	health_bar.value = hp
	health_bar.max_value = max_hp
