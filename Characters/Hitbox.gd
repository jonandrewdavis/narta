# NOTE: This is for AD to understand.
# The way this works is that you can create an Area2D and it'll be extended as Hitbox.
# A hitbox does the HITTING. and it Knocksbacks. Weapons and enemys set this value.
class_name Hitbox
extends Area2D

@export var damage = 1
var knockback_direction: Vector2 = Vector2.ZERO
@export var knockback_force: int = 300

var body_inside: bool = false

@onready var collision_shape: CollisionShape2D = get_child(0)
@onready var timer: Timer = Timer.new()

# NOTE: This is interesting boilerplate to avoid Connect
func _init():
	var __ = connect("body_entered",Callable(self,"_on_body_entered"))
	__ = connect("body_exited",Callable(self,"_on_body_exited"))
	
func _ready() -> void:
	assert(collision_shape != null)
	timer.wait_time = 1
	add_child(timer)
	

# NOTE: I need to better understand on body entered here, and collide
func _on_body_entered(body: PhysicsBody2D) -> void:
	print('body entered', body)
	body_inside = true
	timer.start()
	while body_inside:
		_collide(body)
		await timer.timeout
	
	
func _on_body_exited(_body: CharacterBody2D) -> void:
	body_inside = false
	timer.stop()
	
	
func _collide(body: CharacterBody2D) -> void:
	if body == null or not body.has_method("take_damage"):
		queue_free()
	else:
		print('take damage called', damage)
		body.take_damage(damage, knockback_direction, knockback_force)
