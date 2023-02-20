extends Weapon

# TODO: Force & Damage on animations, to remove them from weapons generics... easier here for now
func get_input() -> void:
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("attack") and not animation_player.is_playing():
		# apply_slow()
		animation_player.play("SwordBase/charge")
	elif Input.is_action_just_released("attack"):
		# remove_slow()
		if animation_player.is_playing() and animation_player.current_animation == "SwordBase/charge":
			hitbox.knockback_force = 215
			animation_player.play("SwordBase/attack")
		elif charge_particles.emitting:
			hitbox.knockback_force = 280
			animation_player.play("SwordBase/strong_attack")
	elif Input.is_action_just_pressed("attack3") and animation_player.has_animation("SwordBase/active_ability") and not is_busy() and can_active_ability:
		can_active_ability = false
		cool_down_timer.start()
		animation_player.play("SwordBase/active_ability")
			
			
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
	animation_player.play("SwordBase/cancel_attack")
