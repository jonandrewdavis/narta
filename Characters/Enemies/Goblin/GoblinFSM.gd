extends FiniteStateMachine

func _init():
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	
func _ready() -> void:
	set_state(states.move)
	
func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.move()
	if state == states.hurt:	
		parent.move()
		
		
func _get_transition() -> int:
	match state:
		states.idle:
			if parent.distance_to_player > parent.MAX_DISTANCE_TO_PLAYER or parent.distance_to_player < parent.MIN_DISTANCE_TO_PLAYER:
				parent.can_attack = false
				return states.move
		states.move:
			if parent.distance_to_player < parent.MAX_DISTANCE_TO_PLAYER and parent.distance_to_player > parent.MIN_DISTANCE_TO_PLAYER:
				parent.can_attack = false
				parent.attack_timer.start(1.6)
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.move
	return -1
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
