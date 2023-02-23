# This hitbox is a lot more complicated. See Hitbox.gd in Characters/
extends Hitbox

# NOTE: See real logic in Hitbox.gd
# Collide does the call to TakeDamage.
func _ready():
	knockback_force = 215
	pass


func _on_body_entered(body: PhysicsBody2D) -> void:
	var parentBody = get_parent().get_parent().get_parent().playerBody.name
	if parentBody == body.name: return
	if body != null and body.has_method("take_damage"):
		body.take_damage(damage, knockback_direction, knockback_force)
