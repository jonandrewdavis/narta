# NOTE: Demon large is the first guy I'm building from scratch, so taking extra notes.
extends FiniteStateMachine

const animationLibrary = "DemonLarge/"

func _init():
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	_add_state("attack")
	
func _ready() -> void:
	print(states)
	set_state(states.idle)
	
# NOTE: This gets a little confusing, because "move" is both a state AND a function.
# NOTE: Not to be too confused wtih "chase", which is distinct, and often both as well. 

# TODO: determine how much of this can be offshored to client only.
# I think this is running for each peer, that's a lot of CPU.... maybe only server needs to figure these out?
# input -> animate, the output is position & animation
# Does state needs to update for creatures each frame, for things like taking damage? Animation can do that.
func _state_logic(_delta: float) -> void:
	#if state == states.move:
		# parent.move()
	if state == states.idle:
		pass
	# TODO: more. add a match statement?
	# TODO: Maybe not, as you can do parent.chase(), move & chase... on states.move.
	
		
func _get_transition() -> int:
	match state:
		states.idle:
			# This will Idle forever.
			# TODO: detect the player and run at them.
			return states.idle
			# if parent.distance_to_player > parent.MAX_DISTANCE_TO_PLAYER or parent.distance_to_player < parent.MIN_DISTANCE_TO_PLAYER:
				#return states.move
		states.move:
		#	if parent.distance_to_player < parent.MAX_DISTANCE_TO_PLAYER and parent.distance_to_player > parent.MIN_DISTANCE_TO_PLAYER:
			return states.idle
		states.hurt:
			# NOTE: This represents stunlock.
			if not animation_player.is_playing():
				return states.move
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			animation_player.play(animationLibrary + "idle")
		states.move:
			animation_player.play(animationLibrary + "move")
		states.hurt:
			animation_player.play(animationLibrary + "hurt")
		states.dead:
			animation_player.play(animationLibrary + "dead")
		states.dead:
			animation_player.play(animationLibrary + "attack")
