class_name Enemy
extends Character

var path = 0

@onready var path_timer: Timer = $PathTimer
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var PZ = playerDetectionZone
@onready var hitbox: Area2D = $Hitbox

var CoalItem = preload("res://Items/CoalItem.tscn")

# TODO: explode packed scene or shader destroy

# on enter, they're controlled by the server.
func _enter_tree():
	set_multiplayer_authority(1)

func _ready() -> void:
	print('DEBUG: Mob Ready')
	max_speed = 35
	state_machine.set_state(0)

# NOTE: THIS IS FOR OFFENSIVE PURPOSES. This dir is the direction the enemy is moving.
func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()

func _physics_process(delta):
			if PZ.player != null:
				accelerate_towards_point(PZ.player.global_position, delta)
			else:
				pass
	# if softCollision.is_colliding():
	#	velocity += softCollision.get_push_vector() * delta * 400
	# velocity = move_and_slide(velocity).

func chase():
	pass

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	$AnimatedSprite2D.flip_h = velocity.x < 0
	move_and_slide()
	
func _on_path_timer_timeout():
	# if is_instance_valid(PZ.player):
	#	chase()
	# else:
	#	path_timer.stop()
	#	mov_direction = Vector2.ZERO
	pass
		
func _get_path_to_player() -> void:
	# print(' i want to move towards')
	# if player != null:
	#	path = NavigationServer2D.map_get_path(map, global_position, player.position, false, 1)
	pass

func _get_path_to_move_away_from_player() -> void:
	# print(' i want to move away but i have no path')
	# var dir: Vector2 = (global_position - PZ.player.position).normalized()
	# spath = navigation.get_simple_path(global_position, global_position + dir * 100)
	pass

@rpc('any_peer')
func _die():
	var world = get_tree().get_root().get_node("Main").get_node("World")
	if world != null:
		var newCoal = CoalItem.instantiate()
		newCoal.position = global_position
		world.add_child(newCoal, true)
