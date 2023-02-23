class_name Enemy
extends Character

var path = 0

@onready var attack_timer = $AttackTimer
@onready var path_timer = $PathTimer
@onready var PZ =  $PlayerDetectionZone
@onready var enemy_hitbox: Area2D = $EnemyHitbox

var CoalItem = preload("res://Items/CoalItem.tscn")

# TODO: explode packed scene or shader destroy
func _enter_tree():
	set_multiplayer_authority(1)

# NOTE: THIS IS FOR OFFENSIVE PURPOSES. This dir is the direction the enemy is moving.
func _process(_delta: float) -> void:
	enemy_hitbox.knockback_direction = velocity.normalized()

func chase():
	if PZ.player != null:
		accelerate_towards_point(PZ.player.global_position)

func accelerate_towards_point(point):
	mov_direction = global_position.direction_to(point)
	$AnimatedSprite2D.flip_h = velocity.x < 0

func _get_path_to_player() -> void:
	# if player != null:
	#	path = NavigationServer2D.map_get_path(map, global_position, player.position, false, 1)
	if PZ.player != null:
		accelerate_towards_point(PZ.player.global_position)
	pass

func _get_path_to_move_away_from_player() -> void:
	# var dir: Vector2 = (global_position - PZ.player.position).normalized()
	# spath = navigation.get_simple_path(global_position, global_position + dir * 100)
	if PZ.player != null:
		var dir: Vector2 = (global_position - PZ.player.position).normalized()
		accelerate_towards_point(global_position + dir)


# There are a number of bugs with Multiplayer Spawner
# that can happen here, between queuefree & dropping loot
# so far, no coal in the MultiplayerSpawner, still spawns all loot, for all players
#
func _die():
	var world = get_tree().get_root().get_node("Main").get_node("World")
	if world != null:
		var newCoal = CoalItem.instantiate()
		newCoal.position = global_position
		world.add_child(newCoal, true)
	hide()
	if not is_multiplayer_authority(): return
	await get_tree().create_timer(0.2).timeout
	queue_free()
	
	
# TODO: this is an attack, called from animation, should likely be in state machine
# in the future
func _launch():
	take_knockback(0, velocity, 4)


func _on_attack_timer_timeout():
	pass # Replace with function body.

func _on_path_timer_timeout():
	pass # Replace with function body.
