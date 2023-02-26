extends Enemy

const THROWABLE_KNIFE_SCENE: PackedScene = preload("res://Characters/Enemies/Goblin/ThrowableKnife.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 90
const MIN_DISTANCE_TO_PLAYER: int = 50

@export var projectile_speed: int = 100

var can_attack: bool = true
var distance_to_player: float

@onready var aim_raycast: RayCast2D = $AimRayCast

func ready():
	path_timer.start()

func _throw_knife() -> void:
	var projectile: Area2D = THROWABLE_KNIFE_SCENE.instantiate()
	if PZ.player != null:
		projectile.launch(self, global_position, (PZ.player.position - global_position).normalized(), projectile_speed)
		get_tree().current_scene.add_child(projectile)


func _on_path_timer_timeout():
	if is_instance_valid(PZ.player):
		distance_to_player = (PZ.player.position - global_position).length()
	if distance_to_player > MAX_DISTANCE_TO_PLAYER:
		_get_path_to_player()
	elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
		_get_path_to_move_away_from_player()
	elif is_instance_valid(PZ.player):
		aim_raycast.target_position = PZ.player.position - global_position

	if can_attack and state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
		can_attack = false
		_throw_knife()
	else:
		path_timer.start()

func _on_attack_timer_timeout():
	can_attack = true
