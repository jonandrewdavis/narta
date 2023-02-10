class_name Character
extends CharacterBody2D

const HIT_EFFECT_SCENE: PackedScene = preload("res://Characters/HitEffect.tscn")

# const FRICTION: float = 0.15

@export var max_hp: int = 3
@export var hp: int = 3 
signal hp_changed(new_hp)

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

func move() -> void:
	pass

	
func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.hurt and state_machine.state != state_machine.states.dead:
		_spawn_hit_effect()
		hp -= dam
		if name == "Player":
			SavedData.hp = hp
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
			velocity += dir * force
		else:
			state_machine.set_state(state_machine.states.dead)
			velocity += dir * force * 1.2
		
		
func set_hp(new_hp: int) -> void:
	print('whos settinghp', new_hp)
	hp = clamp(new_hp, 0, max_hp)
	if hp < max_hp:
		health_bar.visible = true
		health_bar.value = hp
		health_bar.max_value = max_hp
	if hp == 0:
		health_bar.visible = false
	# emit_signal("hp_changed", hp)
	
	
func _spawn_hit_effect() -> void:
	var hit_effect: Sprite2D = HIT_EFFECT_SCENE.instantiate()
	add_child(hit_effect)
