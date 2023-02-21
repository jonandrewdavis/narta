extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("hurt")
	_add_state("dead")
	
func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	pass

func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing() and animation_player != null:
				return states.idle
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.hurt:
			animation_player.play("hurt")
