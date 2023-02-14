extends FiniteStateMachine

const animationLibrary = "DemonLarge/"


func _init():
	_add_state("idle")
	_add_state("chase")
	_add_state("hurt")
	_add_state("dead")
	_add_state("charge")
	_add_state("launch")


func _ready() -> void:
	set_state(states.idle)
	
# NOTE: This gets a little confusing, because "move" is both a state AND a function.
# NOTE: Not to be too confused wtih "chase", which is distinct, and often both as well. 

# TODO: determine how much of this can be offshored to client only.
# I think this is running for each peer, that's a lot of CPU.... maybe only server needs to figure these out?
# input -> animate, the output is position & animation
# Does state needs to update for creatures each frame, for things like taking damage? Animation can do that.

# NOTE: Not including "move" represents stunlock.
func _state_logic(_delta: float) -> void:
	if state == states.hurt:
		parent.move()
	if state == states.chase:
		parent.chase()
		parent.move()
	if state == states.charge:
		parent.chase()
	if state == states.launch:
		parent.move()
	if states == states.dead:
		parent.move()
	
func _get_transition() -> int:
	match state:
		states.charge:
			if not animation_player.is_playing():
				return states.launch
		states.launch:
			if not animation_player.is_playing():
				return states.chase
		states.chase:
			if parent.PZ.player == null:
				return states.idle
			elif (parent.PZ.player.position - parent.position).length() <= parent.MIN_DISTANCE_TO_PLAYER: 
				return states.charge
		states.idle:
			if parent.PZ.player != null:
				return states.chase
		states.hurt:
			if not animation_player.is_playing():
				return states.chase
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play(animationLibrary + "idle")
		states.chase:
			animation_player.play(animationLibrary + "move")
		states.hurt:
			animation_player.play(animationLibrary + "hurt")
		states.dead:
			animation_player.play(animationLibrary + "dead")
		states.charge:
			animation_player.play(animationLibrary + "charge")
		states.launch:
			animation_player.play(animationLibrary + "attack")
