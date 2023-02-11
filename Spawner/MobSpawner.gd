extends Node2D

var DemonSmall = preload("res://Characters/Enemies/DemonSmall/DemonSmall.tscn")
var Goblin = preload("res://Characters/Enemies/Goblin/Goblin.tscn")


@onready var spawnBoundary1 =  $Spawn1/SpawnShape.shape.extents
@onready var spawnOrigin1 = $Spawn1/SpawnShape.global_position

@onready var spawnBoundary2 =  $Spawn2/SpawnShape2.shape.extents
@onready var spawnOrigin2 = $Spawn2/SpawnShape2.global_position

func gen_random_pos():
	var x = 0
	var y = 0
	if randi() % 2 == 0:
		x = randi_range(spawnOrigin1.x, spawnOrigin1.x + spawnBoundary1.x)
		y = randi_range(spawnOrigin1.y, spawnOrigin1.y + spawnBoundary1.y)
	else:
		x = randi_range(spawnOrigin2.x, spawnOrigin2.x + spawnBoundary2.x)
		y = randi_range(spawnOrigin2.y, spawnOrigin2.y + spawnBoundary2.y)
	return Vector2(x, y)

func _on_timer_timeout():
	add_enemy()

func add_enemy():
	var newDemon = DemonSmall.instantiate()
	newDemon.global_position = gen_random_pos()
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
