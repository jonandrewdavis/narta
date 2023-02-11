extends Node2D

var DemonSmall = preload("res://Characters/Enemies/DemonSmall/DemonSmall.tscn")
var Goblin = preload("res://Characters/Enemies/Goblin/Goblin.tscn")

func _on_timer_timeout():
	add_enemy()

func add_enemy():
	var newDemon = DemonSmall.instantiate()
	# newDemon.global_position = get_random_position()
	get_parent().add_child(newDemon, true)	


func get_random_position(up = true, down = true, left = true, right = true):
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(-500 - vpr.x/2, -500 - vpr.y/2)
	var bottom_right = Vector2(500 + vpr.x/2, 500 + vpr.y/2)
	var pos_side = []
	if up:
		pos_side.append("up")
	if down:
		pos_side.append("down")
	if right:
		pos_side.append("right")
	if left:
		pos_side.append("left")
	
	var get_rand = randi() % pos_side.size()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side[get_rand]:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = Vector2(bottom_right.x, top_left.y)
		"down":
			spawn_pos1 = Vector2(top_left.x, bottom_right.y)
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = Vector2(bottom_right.x, top_left.y)
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = Vector2(top_left.x, bottom_right.y)
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos2.y, spawn_pos2.y)
	return Vector2(x_spawn,y_spawn)
