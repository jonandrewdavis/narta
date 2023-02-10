class_name Enemy
extends Character

var path = 0

@onready var path_timer: Timer = $PathTimer
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var PZ = playerDetectionZone
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	# This should be a signal for "die":
	# var __ = connect("tree_exited", get_parent(), "_on_enemy_killed")
	print('Ready, mob', state_machine)
	max_speed = 50
	state_machine.set_state(0)
		
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
	pass
	# if is_instance_valid(PZ.player):
	#	chase()
	# else:
	#	path_timer.stop()
	#	mov_direction = Vector2.ZERO
		
func _get_path_to_player() -> void:
	# print(' i want to move towards')
	#print(player, map)
	# if player != null:
	#	path = NavigationServer2D.map_get_path(map, global_position, player.position, false, 1)
	pass

func _get_path_to_move_away_from_player() -> void:
	# print(' i want to move away but i have no path')
	# var dir: Vector2 = (global_position - PZ.player.position).normalized()
	# spath = navigation.get_simple_path(global_position, global_position + dir * 100)
	pass
