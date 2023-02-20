extends Node2D

@onready var ap = get_node("AnimationPlayer")
@onready var sprite = get_node("Sprite2D")


var IronOre = preload("res://Items/Mineables/Iron/IronOreItem.tscn")

var hp = 5

func on_interact(_body: CharacterBody2D) -> void:
	pass
	
func on_mine(mining_strength: int):
	hp -= mining_strength 
	if hp > 0:
	#	sprite.material.set_shader_parameter("active", true)
	#	sprite.material.set_shader_parameter("solid_color", Color(0, 0, 0, 1 - 0.3 * hp))
		ap.play('hit')
	else:
		call_deferred('drop_loot')
		
func drop_loot():
	var newIron = IronOre.instantiate()
	newIron.position = global_position
	get_parent().add_child(newIron)
	hide()
	# do something, then queue free
	await get_tree().create_timer(0.2).timeout
	queue_free()
