extends AnimatedSprite2D


func _ready() -> void:
	playing = true


func _on_SpawnExplosion_animation_finished() -> void:
	queue_free()
