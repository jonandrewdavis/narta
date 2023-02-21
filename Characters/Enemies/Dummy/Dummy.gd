extends Enemy

@onready var number = $Numbers

func _ready():
	hp = 9999

func _die():
	pass


func take_damage(dam: int, dir: Vector2, force: int) -> void:
	if state_machine.state != state_machine.states.dead:
		number.text = str(dam)
		velocity += dir * force
		if hp > 0:
			state_machine.set_state(state_machine.states.hurt)
		else:
			state_machine.set_state(state_machine.states.dead)
		_spawn_hit_effect()
		_update_health_bar()
