extends Hitbox

@onready var enemy_parent = get_parent()

func _on_body_entered(body: CharacterBody2D) -> void:
	if body != null and body.has_method("take_damage"):
		# print('collide calling damage, d: ', knockback_direction, 'f: ', knockback_force)
		body.take_damage(damage, knockback_direction, knockback_force)
		if enemy_parent.has_method('take_knockback'):
			enemy_parent.take_knockback(0, -knockback_direction, 200)
