extends Enemy

const MIN_DISTANCE_TO_PLAYER = 52

# TODO: If he makes contact, tell him to stop for a good half sec. (no state.move()).

func _ready() -> void:
	hp = 10
	max_speed = 40
	state_machine.set_state(0)
	
func _launch():

	take_knockback(0, velocity, 5)
	
func _show_shader():
	sprite.material.set_shader_parameter("active", true)

func _reset_shader():
	sprite.material.set_shader_parameter("active", false)
