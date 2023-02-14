extends Enemy

const MIN_DISTANCE_TO_PLAYER = 52

func _ready() -> void:
	max_speed = 40
	state_machine.set_state(0)
	
func _launch():
	take_knockback(0, velocity, 5)
