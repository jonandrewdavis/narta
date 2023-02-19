# This hitbox is a lot more complicated. See Hitbox.gd in Characters/
extends Hitbox

# NOTE: See real logic in Hitbox.gd
# Collide does the call to TakeDamage.
func _ready():
	knockback_force = 215
	pass
