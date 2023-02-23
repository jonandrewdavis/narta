extends Weapon


func get_input() -> void:
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("attack") and not animation_player.is_playing():
		pass
	elif Input.is_action_just_released("attack") :
		animation_player.play("swing")



func cancel_attack() -> void:
	animation_player.play("RESET")
