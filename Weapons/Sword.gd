extends Weapon

@export var combo = false

func _ready():
	hitbox.knockback_force = 200

# TODO: Force & Damage on animations, to remove them from weapons generics... easier here for now
func get_input() -> void:
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("attack") and not animation_player.is_playing():
		apply_slow()
		animation_player.play("SwordBase/charge")
	elif Input.is_action_just_released("attack"):
		remove_slow()
		if not animation_player.is_playing() and charge_particles.emitting and charge_particles.amount > 30:
			hitbox.knockback_force = 280
			animation_player.play("SwordBase/strong_attack")
		if animation_player.is_playing() and combo == true and animation_player.current_animation == 'SwordBase/attack':
			animation_player.stop()
			animation_player.play("SwordBase/attack_2")
		elif animation_player.is_playing() and combo == true and animation_player.current_animation == 'SwordBase/attack_2':
			combo = false
			animation_player.stop()
			animation_player.play("SwordBase/attack_3")
		elif animation_player.is_playing() and animation_player.current_animation == "SwordBase/charge":
			hitbox.knockback_force = 200
			animation_player.play("SwordBase/attack")
	
	if Input.is_action_just_pressed("attack2") and not animation_player.is_playing() :
		cancel_attack()			
		animation_player.stop()
		apply_slow()
		animation_player.play("SwordBase/active_ability")
	elif Input.is_action_just_released("attack2") and not animation_player.is_playing():
		animation_player.stop()
		cancel_attack()			
		remove_slow()
		
func cancel_attack() -> void:
	animation_player.play("SwordBase/cancel_attack")


