class_name Enemy
extends Character

var path

@onready var player = get_tree().get_root().get_node('TestBox').get_node('Player')
@onready var path_timer: Timer = $PathTimer

func _ready() -> void:
	# This should be a signal for "die":
	# var __ = connect("tree_exited", get_parent(), "_on_enemy_killed")
	print('Ready, mob')
	
func chase() -> void:
	# print('Chase', path)
	if path:
		var vector_to_next_point: Vector2 = path[0] - global_position
		var distance_to_next_point: float = vector_to_next_point.length()
		if distance_to_next_point < 3:
			path.remove(0)
			if not path:
				return
		mov_direction = vector_to_next_point
		
		if vector_to_next_point.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif vector_to_next_point.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true

func _on_path_timer_timeout():
	# print('timeout', player)
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		path = []
		mov_direction = Vector2.ZERO
		
		
func _get_path_to_player() -> void:
	#print(player, map)
	# if player != null:
	#	path = NavigationServer2D.map_get_path(map, global_position, player.position, false, 1)
	pass
