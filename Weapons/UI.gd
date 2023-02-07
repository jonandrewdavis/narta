extends CanvasLayer

@onready var ability_icon: TextureProgressBar = get_node("AbilityIcon")
@onready var tween: Tween = create_tween()


func recharge_ability_animation(time: float) -> void:
	var __ = tween.interpolate_property(ability_icon, "value", 100, 0, time)
	assert(__)
	__ = tween.start()
	assert(__)

