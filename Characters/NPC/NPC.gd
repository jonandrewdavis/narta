extends CharacterBody2D

@onready var IZ: Area2D = $Interact
@onready var text = $Textbox
@onready var key = $AnimatedSprite2D

var players_in_area = []

func update_text():
	if players_in_area.size() > 1:
		pass
		# text.show()
	else:
		text.hide()

func update_key():
	if players_in_area.size() > 1:
		pass
		key.show()
	else:
		key.hide()

func _on_interact_body_entered(body):
	players_in_area.push_front(body)
	update_text()
	update_key()

func _on_interact_body_exited(_body):
	players_in_area.pop_back()
	update_text()
	update_key()

func _on_interact(_body: CharacterBody2D) -> void:
	if text.visible:
		text.hide()
		key.hide()
	elif not text.visible:
		key.hide()
		text.show()
