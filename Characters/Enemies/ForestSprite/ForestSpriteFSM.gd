extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("chase")
	_add_state("hurt")
	_add_state("dead")
	
func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	if state == states.hurt:
		parent.move()
		parent.mov_direction = Vector2.ZERO
	if state == states.chase:
		parent.chase()
		parent.move()
	if state == states.dead:
		parent.move()
		parent.mov_direction = Vector2.ZERO

func _get_transition() -> int:
	match state:
		states.chase:
			if parent.PZ.player == null:
				return states.idle
		states.idle:
			if parent.PZ.player != null:
				return states.chase
		states.hurt:
			if not animation_player.is_playing() and animation_player != null:
				return states.chase
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.chase:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
