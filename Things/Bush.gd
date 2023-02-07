extends Node2D

# TODO: Effects

func _on_hurtbox_area_entered(area):
	queue_free()
