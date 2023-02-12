extends Sprite2D

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

# this is only for hit effect
func _ready() -> void:
	animation_player.play("animation")
