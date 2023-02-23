extends Weapon


func get_input() -> void:
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("attack") and not animation_player.is_playing():
		pass
	elif Input.is_action_just_released("attack") :
		animation_player.play("swing")


func move(mouse_direction: Vector2) -> void:
	if not is_multiplayer_authority(): return
	if ranged_weapon:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		if not animation_player.is_playing() or animation_player.current_animation == "SwordBase/charge":
			rotation = mouse_direction.angle()
			hitbox.knockback_direction = mouse_direction
			if scale.y == 1 and mouse_direction.x < 0:
				scale.y = -1
			elif scale.y == -1 and mouse_direction.x > 0:
				scale.y = 1

func cancel_attack() -> void:
	animation_player.play("RESET")
