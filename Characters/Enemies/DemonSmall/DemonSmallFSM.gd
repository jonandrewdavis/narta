extends FiniteStateMachine


func _init():
	_add_state("chase")
	_add_state("hurt")
	_add_state("dead")
	
func _ready() -> void:
	set_state(states.chase)

# this doesn't do anythign
func _state_logic(_delta: float) -> void:
	if state == states.chase:
		parent.chase()
		parent.move()
	
		
func _get_transition() -> int:

	match state:
		states.hurt:
			if not animation_player.is_playing() and animation_player != null:
				return states.chase
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.chase:
			if animation_player.has_animation("walk"):
				animation_player.play("walk")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
			parent.max_speed = 0
