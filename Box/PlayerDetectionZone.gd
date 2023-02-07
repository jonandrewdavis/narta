extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_body_entered(body):
	print('ent', body)
	player = body

func _on_body_exited(body):
	print('x')
	player = null
