extends CharacterBody2D

@onready var IZ: Area2D = $Interact
@onready var text = $Textbox

var players_in_area = []

func update_text():
	print(players_in_area)
	if players_in_area.size() > 1:
		text.show()
	else:
		text.hide()

func _on_interact_body_entered(body):
	players_in_area.push_front(body)
	update_text()

func _on_interact_body_exited(_body):
	players_in_area.pop_back()
	update_text()
