# This hitbox is a lot more complicated. See Hitbox.gd
extends Hitbox

func _ready():
	knockback_force = 215
	pass
# this is meant to clear our bushes and stuff.
func _on_Hitbox_area_entered(area: Area2D) -> void:
	pass
	# area.queue_free()

# NOTE: See real logic in Hitbox.gd
# Collide does the call to TakeDamage.
